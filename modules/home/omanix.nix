{
  flake.homeModules.omanix =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        alacritty
        gum
        libxkbcommon
        walker
        (writeShellScriptBin "omanix-cmd-terminal-cwd" ''
          # Go from current active terminal to its child shell process and run cwd there
          terminal_pid=$(hyprctl activewindow | awk '/pid:/ {print $2}')
          shell_pid=$(pgrep -P "$terminal_pid" | tail -n1)

          if [[ -n $shell_pid ]]; then
            cwd=$(readlink -f "/proc/$shell_pid/cwd" 2>/dev/null)

            if [[ -d $cwd ]]; then
              echo "$cwd"
            else
              echo "$HOME"
            fi
          else
            echo "$HOME"
          fi
        '')
        (writeShellScriptBin "omanix-launch-browser" ''
          default_browser=$(xdg-settings get default-web-browser)
          browser_exec=$(sed -n 's/^Exec=\([^ ]*\).*/\1/p' {~/.local,~/.nix-profile,/usr}/share/applications/$default_browser 2>/dev/null | head -1)

          if [[ $browser_exec = "" ]]; then
            browser_exec=$BROWSER
          fi

          if [[ $browser_exec =~ (firefox|zen|librewolf) ]]; then
            private_flag="--private-window"
          else
            private_flag="--incognito"
          fi

          exec setsid uwsm-app -- "$browser_exec" "''${@/--private/$private_flag}"
        '')
        (writeShellScriptBin "omanix-launch-editor" ''
          case "${"EDITOR:-nvim"}" in
          nvim | vim | nano | micro | hx | helix)
            exec setsid uwsm-app -- "$TERMINAL" -e "$EDITOR" "$@"
            ;;
          *)
            exec setsid uwsm-app -- "$EDITOR" "$@"
            ;;
          esac
        '')
        (writeShellScriptBin "omanix-launch-floating-terminal-with-presentation" ''
          cmd="$*"
          exec setsid uwsm-app -- alacritty -o font.size=9 --class=Omanix --title=Omanix -e bash -c "omanix-show-logo; $cmd; omanix-show-done"
        '')
        (writeShellScriptBin "omanix-launch-walker" ''
          # Ensure elephant is running before launching walker
          if ! pgrep -x elephant > /dev/null; then
            setsid uwsm-app -- elephant &
          fi

          # Ensure walker service is running
          if ! pgrep -f "walker --gapplication-service" > /dev/null; then
            setsid uwsm-app -- walker --gapplication-service &
          fi

          exec walker --width 644 --maxheight 300 --minheight 300 "$@"
        '')
        (writeShellScriptBin "omanix-menu" ''
          # Set to true when going directly to a submenu, so we can exit directly
          BACK_TO_EXIT=false

          back_to() {
            local parent_menu="$1"

            if [[ "$BACK_TO_EXIT" == "true" ]]; then
              exit 0
            elif [[ -n "$parent_menu" ]]; then
              "$parent_menu"
            else
              show_main_menu
            fi
          }

          menu() {
            local prompt="$1"
            local options="$2"
            local extra="$3"
            local preselect="$4"

            read -r -a args <<<"$extra"

            if [[ -n "$preselect" ]]; then
              local index
              index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
              if [[ -n "$index" ]]; then
                args+=("-c" "$index")
              fi
            fi

            echo -e "$options" | omanix-launch-walker --dmenu --width 295 --minheight 1 --maxheight 600 -p "$prompt…" "''${args[@]}" 2>/dev/null
          }

          terminal() {
            alacritty --class=Omanix -e "$@"
          }

          present_terminal() {
            omanix-launch-floating-terminal-with-presentation $1
          }

          open_in_editor() {
            notify-send "Editing config file" "$1"
            omanix-launch-editor "$1"
          }

          show_learn_menu() {
            case $(menu "Learn" "  Keybindings\n  Omarchy\n  Hyprland\n󰣇  Arch\n  Neovim\n󱆃  Bash") in
            *Keybindings*) omanix-menu-keybindings ;;
            *Omarchy*) omarchy-launch-webapp "https://learn.omacom.io/2/the-omarchy-manual" ;;
            *Hyprland*) omarchy-launch-webapp "https://wiki.hypr.land/" ;;
            *Arch*) omarchy-launch-webapp "https://wiki.archlinux.org/title/Main_page" ;;
            *Bash*) omarchy-launch-webapp "https://devhints.io/bash" ;;
            *Neovim*) omarchy-launch-webapp "https://www.lazyvim.org/keymaps" ;;
            *) show_main_menu ;;
            esac
          }

          show_trigger_menu() {
            case $(menu "Trigger" "  Capture\n  Share\n󰔎  Toggle") in
            *Capture*) show_capture_menu ;;
            *Share*) show_share_menu ;;
            *Toggle*) show_toggle_menu ;;
            *) show_main_menu ;;
            esac
          }

          show_capture_menu() {
            case $(menu "Capture" "  Screenshot\n  Screenrecord\n󰃉  Color") in
            *Screenshot*) show_screenshot_menu ;;
            *Screenrecord*) show_screenrecord_menu ;;
            *Color*) pkill hyprpicker || hyprpicker -a ;;
            *) show_trigger_menu ;;
            esac
          }

          show_screenshot_menu() {
            case $(menu "Screenshot" "  Snap with Editing\n  Straight to Clipboard") in
            *Editing*) omarchy-cmd-screenshot smart ;;
            *Clipboard*) omarchy-cmd-screenshot smart clipboard ;;
            *) show_capture_menu ;;
            esac
          }

          show_screenrecord_menu() {
            case $(menu "Screenrecord" "  Region\n  Region + Audio\n  Display\n  Display + Audio\n  Display + Webcam") in
            *"Region + Audio"*) omarchy-cmd-screenrecord region --with-audio ;;
            *Region*) omarchy-cmd-screenrecord ;;
            *"Display + Audio"*) omarchy-cmd-screenrecord output --with-audio ;;
            *"Display + Webcam"*) omarchy-cmd-screenrecord output --with-audio --with-webcam ;;
            *Display*) omarchy-cmd-screenrecord output ;;
            *) back_to show_capture_menu ;;
            esac
          }

          show_share_menu() {
            case $(menu "Share" "  Clipboard\n  File \n  Folder") in
            *Clipboard*) terminal bash -c "omarchy-cmd-share clipboard" ;;
            *File*) terminal bash -c "omarchy-cmd-share file" ;;
            *Folder*) terminal bash -c "omarchy-cmd-share folder" ;;
            *) back_to show_trigger_menu ;;
            esac
          }

          show_toggle_menu() {
            case $(menu "Toggle" "󱄄  Screensaver\n󰔎  Nightlight\n󱫖  Idle Lock\n󰍜  Top Bar") in
            *Screensaver*) omarchy-toggle-screensaver ;;
            *Nightlight*) omarchy-toggle-nightlight ;;
            *Idle*) omarchy-toggle-idle ;;
            *Bar*) omarchy-toggle-waybar ;;
            *) show_trigger_menu ;;
            esac
          }

          show_style_menu() {
            case $(menu "Style" "󰸌  Theme\n  Font\n  Background\n  Hyprland\n󱄄  Screensaver\n  About") in
            *Theme*) show_theme_menu ;;
            *Font*) show_font_menu ;;
            *Background*) omarchy-theme-bg-next ;;
            *Hyprland*) open_in_editor ~/.config/hypr/looknfeel.conf ;;
            *Screensaver*) open_in_editor ~/.config/omarchy/branding/screensaver.txt ;;
            *About*) open_in_editor ~/.config/omarchy/branding/about.txt ;;
            *) show_main_menu ;;
            esac
          }

          show_theme_menu() {
            theme=$(menu "Theme" "$(omarchy-theme-list)" "" "$(omarchy-theme-current)")
            if [[ "$theme" == "CNCLD" || -z "$theme" ]]; then
              back_to show_style_menu
            else
              omarchy-theme-set "$theme"
            fi
          }

          show_font_menu() {
            theme=$(menu "Font" "$(omarchy-font-list)" "--width 350" "$(omarchy-font-current)")
            if [[ "$theme" == "CNCLD" || -z "$theme" ]]; then
              back_to show_style_menu
            else
              omarchy-font-set "$theme"
            fi
          }

          show_setup_menu() {
            local options="  Audio\n  Wifi\n󰂯  Bluetooth\n󱐋  Power Profile\n󰍹  Monitors"
            [ -f ~/.config/hypr/bindings.conf ] && options="$options\n  Keybindings"
            [ -f ~/.config/hypr/input.conf ] && options="$options\n  Input"
            options="$options\n  Defaults\n󰱔  DNS\n  Security\n  Config"

            case $(menu "Setup" "$options") in
            *Audio*) $TERMINAL --class=Wiremix -e wiremix ;;
            *Wifi*)
              rfkill unblock wifi
              omarchy-launch-wifi
              ;;
            *Bluetooth*)
              rfkill unblock bluetooth
              blueberry
              ;;
            *Power*) show_setup_power_menu ;;
            *Monitors*) open_in_editor ~/.config/hypr/monitors.conf ;;
            *Keybindings*) open_in_editor ~/.config/hypr/bindings.conf ;;
            *Input*) open_in_editor ~/.config/hypr/input.conf ;;
            *Defaults*) open_in_editor ~/.config/uwsm/default ;;
            *DNS*) present_terminal omarchy-setup-dns ;;
            *Security*) show_setup_security_menu ;;
            *Config*) show_setup_config_menu ;;
            *) show_main_menu ;;
            esac
          }

          show_setup_power_menu() {
            profile=$(menu "Power Profile" "$(omarchy-powerprofiles-list)" "" "$(powerprofilesctl get)")

            if [[ "$profile" == "CNCLD" || -z "$profile" ]]; then
              back_to show_setup_menu
            else
              powerprofilesctl set "$profile"
            fi
          }

          show_setup_config_menu() {
            case $(menu "Setup" "  Hyprland\n  Hypridle\n  Hyprlock\n  Hyprsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar\n󰞅  XCompose") in
            *Hyprland*) open_in_editor ~/.config/hypr/hyprland.conf ;;
            *Hypridle*) open_in_editor ~/.config/hypr/hypridle.conf && omarchy-restart-hypridle ;;
            *Hyprlock*) open_in_editor ~/.config/hypr/hyprlock.conf ;;
            *Hyprsunset*) open_in_editor ~/.config/hypr/hyprsunset.conf && omarchy-restart-hyprsunset ;;
            *Swayosd*) open_in_editor ~/.config/swayosd/config.toml && omarchy-restart-swayosd ;;
            *Walker*) open_in_editor ~/.config/walker/config.toml && omarchy-restart-walker ;;
            *Waybar*) open_in_editor ~/.config/waybar/config.jsonc && omarchy-restart-waybar ;;
            *XCompose*) open_in_editor ~/.XCompose && omarchy-restart-xcompose ;;
            *) show_main_menu ;;
            esac
          }

          show_setup_security_menu() {
            case $(menu "Setup" "󰈷  Fingerprint\n  Fido2") in
            *Fingerprint*) present_terminal omarchy-setup-fingerprint ;;
            *Fido2*) present_terminal omarchy-setup-fido2 ;;
            *) show_setup_menu ;;
            esac
          }

          show_install_menu() {
            case $(menu "Install" "󰣇  Package\n󰣇  AUR\n  Web App\n  TUI\n  Service\n  Style\n󰵮  Development\n  Editor\n  Terminal\n󱚤  AI\n󰍲  Windows\n  Gaming") in
            *Package*) terminal omarchy-pkg-install ;;
            *AUR*) terminal omarchy-pkg-aur-install ;;
            *Web*) present_terminal omarchy-webapp-install ;;
            *TUI*) present_terminal omarchy-tui-install ;;
            *Service*) show_install_service_menu ;;
            *Style*) show_install_style_menu ;;
            *Development*) show_install_development_menu ;;
            *Editor*) show_install_editor_menu ;;
            *AI*) show_install_ai_menu ;;
            *Windows*) present_terminal "omarchy-windows-vm install" ;;
            *Gaming*) show_install_gaming_menu ;;
            *) show_main_menu ;;
            esac
          }

          show_install_service_menu() {
            case $(menu "Install" "  Dropbox\n  Tailscale\n󰟵  Bitwarden\n  Chromium Account") in
            *Dropbox*) present_terminal omarchy-install-dropbox ;;
            *Tailscale*) present_terminal omarchy-install-tailscale ;;
            *Chromium*) present_terminal omarchy-install-chromium-google-account ;;
            *) show_install_menu ;;
            esac
          }

          show_install_editor_menu() {
            case $(menu "Install" "  VSCode\n  Cursor\n  Zed\n  Sublime Text\n  Helix\n  Emacs") in
            *VSCode*) present_terminal omarchy-install-vscode ;;
            *) show_install_menu ;;
            esac
          }

          show_install_gaming_menu() {
            case $(menu "Install" "  Steam\n  RetroArch [AUR]\n󰍳  Minecraft") in
            *Steam*) present_terminal omarchy-install-steam ;;
            *) show_install_menu ;;
            esac
          }

          show_install_style_menu() {
            case $(menu "Install" "󰸌  Theme\n  Background\n  Font") in
            *Theme*) present_terminal omarchy-theme-install ;;
            *Background*) nautilus ~/.config/omarchy/current/theme/backgrounds ;;
            *) show_install_menu ;;
            esac
          }

          show_install_development_menu() {
            case $(menu "Install" "󰫏  Ruby on Rails\n  Docker DB\n  JavaScript\n  Go\n  PHP\n  Python\n  Elixir\n  Zig\n  Rust\n  Java\n  .NET\n  OCaml\n  Clojure") in
            *Rails*) present_terminal "omarchy-install-dev-env ruby" ;;
            *Docker*) present_terminal omarchy-install-docker-dbs ;;
            *JavaScript*) show_install_javascript_menu ;;
            *Go*) present_terminal "omarchy-install-dev-env go" ;;
            *PHP*) show_install_php_menu ;;
            *Python*) present_terminal "omarchy-install-dev-env python" ;;
            *Elixir*) show_install_elixir_menu ;;
            *Zig*) present_terminal "omarchy-install-dev-env zig" ;;
            *Rust*) present_terminal "omarchy-install-dev-env rust" ;;
            *Java*) present_terminal "omarchy-install-dev-env java" ;;
            *NET*) present_terminal "omarchy-install-dev-env dotnet" ;;
            *OCaml*) present_terminal "omarchy-install-dev-env ocaml" ;;
            *Clojure*) present_terminal "omarchy-install-dev-env clojure" ;;
            *) show_install_menu ;;
            esac
          }

          show_install_javascript_menu() {
            case $(menu "Install" "  Node.js\n  Bun\n  Deno") in
            *Node*) present_terminal "omarchy-install-dev-env node" ;;
            *Bun*) present_terminal "omarchy-install-dev-env bun" ;;
            *Deno*) present_terminal "omarchy-install-dev-env deno" ;;
            *) show_install_development_menu ;;
            esac
          }

          show_install_php_menu() {
            case $(menu "Install" "  PHP\n  Laravel\n  Symfony") in
            *PHP*) present_terminal "omarchy-install-dev-env php" ;;
            *Laravel*) present_terminal "omarchy-install-dev-env laravel" ;;
            *Symfony*) present_terminal "omarchy-install-dev-env symfony" ;;
            *) show_install_development_menu ;;
            esac
          }

          show_install_elixir_menu() {
            case $(menu "Install" "  Elixir\n  Phoenix") in
            *Elixir*) present_terminal "omarchy-install-dev-env elixir" ;;
            *Phoenix*) present_terminal "omarchy-install-dev-env phoenix" ;;
            *) show_install_development_menu ;;
            esac
          }

          show_remove_menu() {
            case $(menu "Remove" "󰣇  Package\n  Web App\n  TUI\n󰸌  Theme\n󰍲  Windows\n󰈷  Fingerprint\n  Fido2") in
            *Package*) terminal omarchy-pkg-remove ;;
            *Web*) present_terminal omarchy-webapp-remove ;;
            *TUI*) present_terminal omarchy-tui-remove ;;
            *Theme*) present_terminal omarchy-theme-remove ;;
            *Windows*) present_terminal "omarchy-windows-vm remove" ;;
            *Fingerprint*) present_terminal "omarchy-setup-fingerprint --remove" ;;
            *Fido2*) present_terminal "omarchy-setup-fido2 --remove" ;;
            *) show_main_menu ;;
            esac
          }

          show_update_menu() {
            case $(menu "Update" " Omarchy\n  Config\n󰸌  Extra Themes\n  Process\n󰇅  Hardware\n  Firmware\n  Password\n  Timezone\n  Time") in
            *Omarchy*) present_terminal omarchy-update ;;
            *Config*) show_update_config_menu ;;
            *Themes*) present_terminal omarchy-theme-update ;;
            *Process*) show_update_process_menu ;;
            *Hardware*) show_update_hardware_menu ;;
            *Firmware*) present_terminal omarchy-update-firmware ;;
            *Timezone*) present_terminal omarchy-tz-select ;;
            *Time*) present_terminal omarchy-reset-time ;;
            *Password*) show_update_password_menu ;;
            *) show_main_menu ;;
            esac
          }

          show_update_process_menu() {
            case $(menu "Restart" "  Hypridle\n  Hyprsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
            *Hypridle*) omarchy-restart-hypridle ;;
            *Hyprsunset*) omarchy-restart-hyprsunset ;;
            *Swayosd*) omarchy-restart-swayosd ;;
            *Walker*) omarchy-restart-walker ;;
            *Waybar*) omarchy-restart-waybar ;;
            *) show_update_menu ;;
            esac
          }

          show_update_config_menu() {
            case $(menu "Use default config" "  Hyprland\n  Hypridle\n  Hyprlock\n  Hyprsunset\n󱣴  Plymouth\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
            *Hyprland*) present_terminal omarchy-refresh-hyprland ;;
            *Hypridle*) present_terminal omarchy-refresh-hypridle ;;
            *Hyprlock*) present_terminal omarchy-refresh-hyprlock ;;
            *Hyprsunset*) present_terminal omarchy-refresh-hyprsunset ;;
            *Plymouth*) present_terminal omarchy-refresh-plymouth ;;
            *Swayosd*) present_terminal omarchy-refresh-swayosd ;;
            *Walker*) present_terminal omarchy-refresh-walker ;;
            *Waybar*) present_terminal omarchy-refresh-waybar ;;
            *) show_update_menu ;;
            esac
          }

          show_update_hardware_menu() {
            case $(menu "Restart" "  Audio\n󱚾  Wi-Fi\n󰂯  Bluetooth") in
            *Audio*) present_terminal omarchy-restart-pipewire ;;
            *Wi-Fi*) present_terminal omarchy-restart-wifi ;;
            *Bluetooth*) present_terminal omarchy-restart-bluetooth ;;
            *) show_update_menu ;;
            esac
          }

          show_update_password_menu() {
            case $(menu "Update Password" "  Drive Encryption\n  User") in
            *Drive*) present_terminal omarchy-drive-set-password ;;
            *User*) present_terminal passwd ;;
            *) show_update_menu ;;
            esac
          }

          show_system_menu() {
            case $(menu "System" "  Lock\n󱄄  Screensaver\n󰤄  Suspend\n󰜉  Restart\n󰐥  Shutdown") in
            *Lock*) omarchy-lock-screen ;;
            *Screensaver*) omarchy-launch-screensaver force ;;
            *Suspend*) systemctl suspend ;;
            *Restart*) omarchy-state clear re*-required && systemctl reboot --no-wall ;;
            *Shutdown*) omarchy-state clear re*-required && systemctl poweroff --no-wall ;;
            *) back_to show_main_menu ;;
            esac
          }

          show_main_menu() {
            go_to_menu "$(menu "Go" "󰀻  Apps\n󰧑  Learn\n󱓞  Trigger\n  Style\n  Setup\n󰉉  Install\n󰭌  Remove\n  Update\n  About\n  System")"
          }

          go_to_menu() {
            case "''${1,,}" in
            *apps*) walker -p "Launch…" ;;
            *learn*) show_learn_menu ;;
            *trigger*) show_trigger_menu ;;
            *share*) show_share_menu ;;
            *style*) show_style_menu ;;
            *theme*) show_theme_menu ;;
            *screenshot*) show_screenshot_menu ;;
            *screenrecord*) show_screenrecord_menu ;;
            *setup*) show_setup_menu ;;
            *power*) show_setup_power_menu ;;
            *install*) show_install_menu ;;
            *remove*) show_remove_menu ;;
            *update*) show_update_menu ;;
            *about*) omarchy-launch-about ;;
            *system*) show_system_menu ;;
            esac
          }

          if [[ -n "$1" ]]; then
            BACK_TO_EXIT=true
            go_to_menu "$1"
          else
            show_main_menu
          fi
        '')
        (writeShellScriptBin "omanix-menu-keybindings" ''
          # A script to display Hyprland keybindings defined in your configuration
          # using walker for an interactive search menu.

          declare -A KEYCODE_SYM_MAP

          build_keymap_cache() {
            local keymap
            keymap="$(xkbcli compile-keymap)" || {
              echo "Failed to compile keymap" >&2
              return 1
            }

            while IFS=, read -r code sym; do
              [[ -z "$code" || -z "$sym" ]] && continue
              KEYCODE_SYM_MAP["$code"]="$sym"
            done < <(
              awk '
                BEGIN { sec = "" }
                /xkb_keycodes/ { sec = "codes"; next }
                /xkb_symbols/  { sec = "syms";  next }
                sec == "codes" {
                  if (match($0, /<([A-Za-z0-9_]+)>\s*=\s*([0-9]+)\s*;/, m)) code_by_name[m[1]] = m[2]
                }
                sec == "syms" {
                  if (match($0, /key\s*<([A-Za-z0-9_]+)>\s*\{\s*\[\s*([^, \]]+)/, m)) sym_by_name[m[1]] = m[2]
                }
                END {
                  for (k in code_by_name) {
                    c = code_by_name[k]
                    s = sym_by_name[k]
                    if (c != "" && s != "" && s != "NoSymbol") print c "," s
                  }
                }
              ' <<<"$keymap"
            )
          }

          lookup_keycode_cached() {
            printf '%s\n' "''${KEYCODE_SYM_MAP[$1]}"
          }

          parse_keycodes() {
            local start end elapsed
            [[ "''${DEBUG:-0}" == "1" ]] && start=$(date +%s.%N)
            while IFS= read -r line; do
              if [[ "$line" =~ code:([0-9]+) ]]; then
                code="''${BASH_REMATCH[1]}"
                symbol=$(lookup_keycode_cached "$code" "$XKB_KEYMAP_CACHE")
                echo "''${line/code:''${code}/$symbol}"
              else
                echo "$line"
              fi
            done

            if [[ "$DEBUG" == "1" ]]; then
              end=$(date +%s.%N)
              # fall back to awk if bc is missing
              if command -v bc >/dev/null 2>&1; then
                elapsed=$(echo "$end - $start" | bc)
              else
                elapsed=$(awk -v s="$start" -v e="$end" 'BEGIN{printf "%.6f", (e - s)}')
              fi
              echo "[DEBUG] parse_keycodes elapsed: ''${elapsed}s" >&2
            fi
          }

          # Fetch dynamic keybindings from Hyprland
          #
          # Also do some pre-processing:
          # - Remove standard Omarchy bin path prefix
          # - Remove uwsm prefix
          # - Map numeric modifier key mask to a textual rendition
          # - Output comma-separated values that the parser can understand
          dynamic_bindings() {
            hyprctl -j binds |
              jq -r '.[] | {modmask, key, keycode, description, dispatcher, arg} | "\(.modmask),\(.key)@\(.keycode),\(.description),\(.dispatcher),\(.arg)"' |
              sed -r \
                -e 's/null//' \
                -e 's,~/.local/share/omarchy/bin/,,' \
                -e 's,uwsm app -- ,,' \
                -e 's,uwsm-app -- ,,' \
                -e 's/@0//' \
                -e 's/,@/,code:/' \
                -e 's/^0,/,/' \
                -e 's/^1,/SHIFT,/' \
                -e 's/^4,/CTRL,/' \
                -e 's/^5,/SHIFT CTRL,/' \
                -e 's/^8,/ALT,/' \
                -e 's/^9,/SHIFT ALT,/' \
                -e 's/^12,/CTRL ALT,/' \
                -e 's/^13,/SHIFT CTRL ALT,/' \
                -e 's/^64,/SUPER,/' \
                -e 's/^65,/SUPER SHIFT,/' \
                -e 's/^68,/SUPER CTRL,/' \
                -e 's/^69,/SUPER SHIFT CTRL,/' \
                -e 's/^72,/SUPER ALT,/' \
                -e 's/^73,/SUPER SHIFT ALT,/' \
                -e 's/^76,/SUPER CTRL ALT,/' \
                -e 's/^77,/SUPER SHIFT CTRL ALT,/'
          }

          # Parse and format keybindings
          #
          # `awk` does the heavy lifting:
          # - Set the field separator to a comma ','.
          # - Joins the key combination (e.g., "SUPER + Q").
          # - Joins the command that the key executes.
          # - Prints everything in a nicely aligned format.
          parse_bindings() {
            awk -F, '
          {
              # Combine the modifier and key (first two fields)
              key_combo = $1 " + " $2;

              # Clean up: strip leading "+" if present, trim spaces
              gsub(/^[ \t]*\+?[ \t]*/, "", key_combo);
              gsub(/[ \t]+$/, "", key_combo);

              # Use description, if set
              action = $3;

              if (action == "") {
                  # Reconstruct the command from the remaining fields
                  for (i = 4; i <= NF; i++) {
                      action = action $i (i < NF ? "," : "");
                  }

                  # Clean up trailing commas, remove leading "exec, ", and trim
                  sub(/,$/, "", action);
                  gsub(/(^|,)[[:space:]]*exec[[:space:]]*,?/, "", action);
                  gsub(/^[ \t]+|[ \t]+$/, "", action);
                  gsub(/[ \t]+/, " ", key_combo);  # Collapse multiple spaces to one

                  # Escape XML entities
                  gsub(/&/, "\\&amp;", action);
                  gsub(/</, "\\&lt;", action);
                  gsub(/>/, "\\&gt;", action);
                  gsub(/"/, "\\&quot;", action);
                  gsub(/'"'"'/, "\\&apos;", action);
              }

              if (action != "") {
                  printf "%-35s → %s\n", key_combo, action;
              }
          }'
          }

          monitor_height=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .height')
          menu_height=$((monitor_height * 40 / 100))

          build_keymap_cache

          dynamic_bindings |
            sort -u |
            parse_keycodes |
            parse_bindings |
            walker --dmenu -p 'Keybindings' --width 800 --height "$menu_height"
        '')
        (writeShellScriptBin "omanix-show-done" ''
          echo
          gum spin --spinner "globe" --title "Done! Press any key to close..." -- bash -c 'read -n 1 -s'
        '')
        (writeShellScriptBin "omanix-show-logo" ''
          clear
          echo -e "\033[32m"
          cat <~/.local/share/omanix/logo.txt
          echo -e "\033[0m"
          echo
        '')
      ];
    };
}
