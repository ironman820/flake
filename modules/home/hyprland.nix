{ flakeRoot, ...}:
{
  flake.homeModules.hyprland =
    { config, pkgs, ... }:
    {
      home = {
        sessionVariables.NIXOS_OZONE_WL = "1";
        shellAliases = {
          d = "docker";
          decompress = "tar -xzf";
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
        };
      };
      programs = {
        alacritty.enable = true;
        bash = {
          historyControl = [ "ignoreboth" ];
          historySize = 32768;
          initExtra = ''
            # Compression
            compress() { tar -czf "''${1%/}.tar.gz" "''${1%/}"; }

            # Write iso file to sd card
            iso2sd() {
              if [ $# -ne 2 ]; then
                echo "Usage: iso2sd <input_file> <output_device>"
                echo "Example: iso2sd ~/Downloads/ubuntu-25.04-desktop-amd64.iso /dev/sda"
                echo -e "\nAvailable SD cards:"
                lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
              else
                sudo dd bs=4M status=progress oflag=sync if="$1" of="$2"
                sudo eject $2
              fi
            }

            # Format an entire drive for a single partition using ext4
            format-drive() {
              if [ $# -ne 2 ]; then
                echo "Usage: format-drive <device> <name>"
                echo "Example: format-drive /dev/sda 'My Stuff'"
                echo -e "\nAvailable drives:"
                lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
              else
                echo "WARNING: This will completely erase all data on $1 and label it '$2'."
                read -rp "Are you sure you want to continue? (y/N): " confirm
                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                  sudo wipefs -a "$1"
                  sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
                  sudo parted -s "$1" mklabel gpt
                  sudo parted -s "$1" mkpart primary ext4 1MiB 100%
                  sudo mkfs.ext4 -L "$2" "$([[ $1 == *"nvme"* ]] && echo "''${1}p1" || echo "''${1}1")"
                  sudo chmod -R 777 "/run/media/$USER/$2"
                  echo "Drive $1 formatted and labeled '$2'."
                fi
              fi
            }

            # Transcode a video to a good-balance 1080p that's great for sharing online
            transcode-video-1080p() {
              ffmpeg -i $1 -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy ''${1%.*}-1080p.mp4
            }

            # Transcode a video to a good-balance 4K that's great for sharing online
            transcode-video-4K() {
              ffmpeg -i $1 -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k ''${1%.*}-optimized.mp4
            }

            # Transcode any image to JPG image that's great for shrinking wallpapers
            img2jpg() {
              magick $1 -quality 95 -strip ''${1%.*}.jpg
            }

            # Transcode any image to JPG image that's great for sharing online without being too big
            img2jpg-small() {
              magick $1 -resize 1080x\> -quality 95 -strip ''${1%.*}.jpg
            }

            # Transcode any image to compressed-but-lossless PNG
            img2png() {
              magick "$1" -strip -define png:compression-filter=5 \
                -define png:compression-level=9 \
                -define png:compression-strategy=1 \
                -define png:exclude-chunk=all \
                "''${1%.*}.png"
            }
          '';
        };
        fzf = {
          enable = true;
          enableBashIntegration = true;
          tmux.enableShellIntegration = true;
        };
        hyprlock = {
          enable = true;
          settings = {
            source = "${config.xdg.configHome}/omarchy/current/theme/hyprlock.conf";

            background = {
              monitor = "";
              color = "$color";
              path = "${config.xdg.configHome}/omarchy/current/background";
              blur_passes = 3;
            };
            animations = {
              enabled = false;
            };
            input-field = {
              monitor = "";
              size = "650, 100";
              position = "0, 0";
              halign = "center";
              valign = "center";

              inner_color = "$inner_color";
              outer_color = "$outer_color";
              outline_thickness = 4;

              font_family = "CaskaydiaMono Nerd Font Propo";
              font_color = "$font_color";

              placeholder_text = "Enter Password 󰈷";
              check_color = "$check_color";
              fail_text = "<i>$FAIL ($ATTEMPTS)</i>";

              rounding = 0;
              shadow_passes = 0;
              fade_on_empty = false;
            };
            auth = {
              "fingerprint:enabled" = true;
            };
          };
        };
      };
      services.hypridle =
        let
          omarchy-launch-screensaver = pkgs.writeShellScript "omarchy-launch-screensaver" ''
            # Exit early if we don't have the tte show
            if ! command -v tte &>/dev/null; then
              exit 1
            fi

            # Exit early if screensave is already running
            pgrep -f "alacritty --class Screensaver" && exit 0

            # Allow screensaver to be turned off but also force started
            if [[ -f ~/.local/state/omarchy/toggles/screensaver-off ]] && [[ $1 != "force" ]]; then
              exit 1
            fi

            focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')

            for m in $(hyprctl monitors -j | jq -r '.[] | .name'); do
              hyprctl dispatch focusmonitor $m

              # FIXME: Find a way to make this generic where we it can work for kitty + ghostty
              hyprctl dispatch exec -- \
                alacritty --class Screensaver \
                --config-file ~/.local/share/omarchy/default/alacritty/screensaver.toml \
                -e omarchy-cmd-screensaver
            done

            hyprctl dispatch focusmonitor $focused
          '';
          omarchy-lock-screen = pkgs.writeShellScript "omarchy-lock-screen" ''
            pidof hyprlock || hyprlock &
          '';
        in
        {
          enable = true;
          settings = {
            general = {
              lock_cmd = "${omarchy-lock-screen}";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
              inhibit_sleep = 3;
            };
            listener = [
              {
                timeout = 150;
                on-timeout = "pidof hyprlock || ${omarchy-launch-screensaver}";
              }
              {
                timeout = 300;
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 330;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
              }
            ];
          };
        };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mod" = "SUPER";
          bind = [
            "$mod, Q, exec, kitty"
            "$mod, W, killactive,"
            "$mod, M, exit,"
            # ", Print, exec, grimblast copy area"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            )
          );
        };
      };
      xdg.configFile = {
        "omarchy/current/background".source = flakeRoot + "/.config/backgrounds/voidbringer.png";
        "omarchy/current/theme/hyprlock.conf".text = ''
          $color = rgba(26,27,38,1.0)
          $inner_color = rgba(26,27,38,0.8)
          $outer_color = rgba(205,214,244,1.0)
          $font_color = rgba(205,214,244,1.0)
          $check_color = rgba(68, 157, 171, 1.0)
        '';
        "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      };
    };
}
