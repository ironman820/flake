{
  cell,
  config,
  inputs,
  options,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  a = v.applications;
  h = v.hyprland;
  l = nixpkgs.lib // mine.lib // builtins;
  t = l.types;
  tr = v.transparency;
  v = config.vars;
in {
  options.vars.hyprland = {
    primaryScale = l.mkOpt t.str "1" "Scaling factor for the primary monitor";
    wallpaper = l.mkOpt (t.either t.path t.str) v.wallpaper "Wallpaper to load with hyprpaper";
    windowrule = l.mkOpt (t.listOf t.str) [] "V1 windowrules";
    windowrulev2 = l.mkOpt (t.listOf t.str) [] "V2 windowrules";
  };
  config = {
    vars.hyprland = {
      windowrule = [
        "workspace 9,^(dude.exe)$"
      ];
      windowrulev2 = [
        "tile,class:(Microsoft-edge)"
        "tile,class:(Brave-browser)"
        "tile,class:(Chromium)"
        "float,class:(pavucontrol)"
        "float,class:(blueman-manager)"
        "float,class:(nm-connection-editor)"
        "pin,title:(Barrier)"
        "tile,class:(dude.exe)"
        "opacity 1.0 override 1.0 override,class:^(fim)$"
        "noblur,class:(Wezterm)"
        "noborder,class:(Wezterm)"
        "nodim,class:(Wezterm)"
        "noshadow,class:(Wezterm)"
        "rounding 0,class:(Wezterm)"
        "opacity 1.0 override 1.0 override,class:^(Wezterm)$"
      ];
    };
    #   rofi = enabled;
    #   swappy = enabled;
    #   tui.just.homePersist = mkIf imp [
    #     "mkdir -p /persist/home/.cache/cliphist"
    #   ];
    #   waybar = enabled;
    #   wlogout = enabled;
    #   xdg = {
    #     enable = true;
    #   };
    # };
    programs.hyprlock = {
      enable = true;
      settings = {
        backgrounds = [
          {
            path = "${config.xdg.configHome}/flake/cells/de/homeProfiles/hyprland/__files/suit_up.png";
            blur_passes = 2;
            blur_size = 2;
            vibrancy_darkness = 0.0;
          }
        ];
        input-fields = [
          {
            outline_thickness = 1;
          }
        ];
        labels = [
          {
            text = "";
          }
        ];
      };
    };
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lockCmd = "pidof hyprlock || hyprlock";
          unlockCmd = "";
          afterSleepCmd = "hyprctl dispatch dpms on";
          beforeSleepCmd = "loginctl lock-session";
        };
        listeners = [
          {
            timeout = 299;
            onTimeout = "loginctl lock-session";
            onResume = "";
          }
        ];
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        submap = hotkeys
        bind = $mainMod, X, submap, reset
        submap = reset
      '';
      settings = {
        animations = {
          enabled = true;
          bezier = [
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "smoothOut, 0.5, 0, 0.99, 0.99"
            "smoothIn, 0.5, -0.5, 0.68, 1.5"
          ];
          animation = [
            "windows, 1, 5, overshot, slide"
            "windowsOut, 1, 3, smoothOut"
            "windowsIn, 1, 3, smoothOut"
            "windowsMove, 1, 4, smoothIn, slide"
            "border, 1, 5, default"
            "fade, 1, 5, smoothIn"
            "fadeDim, 1, 5, smoothIn"
            "workspaces, 1, 6, default"
          ];
        };
        "$mainMod" = "SUPER";
        bind = [
          "$mainMod, B, exec, ${a.browser}"
          "$mainMod, Q, killactive"
          "$mainMod, F, fullscreen"
          "$mainMod, E, exec, ${a.terminal} -e ${a.fileManager}"
          "$mainMod, T, exec, ${a.terminal}"
          "$mainMod SHIFT, T, togglefloating"
          "$mainMod SHIFT, J, togglesplit"
          "$mainMod SHIFT, L, exec, hyprlock"
          "$mainMod CTRL, down, workspace, empty"
          "$mainMod CTRL, Q, exec, wlogout"
          "$mainMod, PRINT, exec, ~/.config/hypr/screenshot.sh"
          "$mainMod CTRL, H, exec, ~/.config/hypr/keybindings.sh"
          "$mainMod SHIFT, B, exec, ~/.config/waybar/restart.sh"
          "$mainMod CTRL, F, exec, ${a.terminal} -e ${a.fileManager}"
          "$mainMod CTRL, C, exec, ~/.config/rofi/cliphist.sh"
          "$mainMod, V, exec, ~/.config/rofi/cliphist.sh"
          "$mainMod, R, exec, rofi -show drun"
          "$mainMod SHIFT, R, exec, hyprctl reload"
          "$mainMod SHIFT, W, exec, ~/.config/hypr/wallpaper.sh"
          "$mainMod, X, submap, hotkeys"
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          ", XF86MonBrightnessUp, exec, brightnessctl -q s +10%"
          ", XF86MonBrightnessDown, exec, brightnessctl -q s 10%-"
          ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86Calculator, exec, qalculate-gtk"
          ", XF86Lock, exec, swaylock"
        ];
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 12;
            passes = 6;
            new_optimizations = true;
            ignore_opacity = false;
            xray = true;
          };
          active_opacity = tr.applicationOpacity;
          inactive_opacity = tr.inactiveOpacity;
          fullscreen_opacity = 1;
          drop_shadow = true;
          shadow_range = 30;
          shadow_render_power = 3;
        };
        "device:epic-mouse-v1".sensitivity = -0.5;
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        env = [
          "XCURSOR_SIZE,24"
        ];
        exec-once = [
          "hyprpaper"
          "nm-applet"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "wl-paste --watch cliphist store"
        ];
        general = {
          gaps_in = 10;
          gaps_out = 14;
          border_size = 2;
          layout = "dwindle";
        };
        gestures.workspace_swipe = false;
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          follow_mouse = 1;
          touchpad.natural_scroll = true;
          sensitivity = 0;
        };
        master.new_is_master = true;
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = false;
          vfr = true;
        };
        source = [
          "~/.config/hypr/monitor.conf"
        ];
        windowrule = l.mkAliasDefinitions options.vars.hyprland.windowrule;
        windowrulev2 = l.mkAliasDefinitions options.vars.hyprland.windowrulev2;
        xwayland.force_zero_scaling = true;
      };
      systemd = {
        enable = true;
        variables = let
          inherit (h) primaryScale;
        in [
          "CLUTTER_BACKEND,wayland"
          "DISPLAY"
          "GDK_BACKEND,wayland,x11"
          "GDK_SCALE,1"
          "HYPRLAND_INSTANCE_SIGNATURE"
          "NIXOS_OZONE_WL,1"
          "QT_QPA_PLATFORM,wayland"
          "QT_AUTO_SCREEN_SCALE_FACTOR,${primaryScale}"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "SDL_VIDEODRIVER,wayland"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,wayland"
        ];
      };
    };
    xdg.configFile = {
      "hypr/hyprpaper.conf".text = l.mkIf (h.wallpaper != "") ''
        preload = ${h.wallpaper}
        wallpaper = , ${h.wallpaper}
      '';
      "hypr/keybindings.sh" = {
        executable = true;
        source = pkgs.writeShellScript "keybindings.sh" ''
          #  _              _     _           _ _
          # | | _____ _   _| |__ (_)_ __   __| (_)_ __   __ _ ___
          # | |/ / _ \ | | | '_ \| | '_ \ / _` | | '_ \ / _` / __|
          # |   <  __/ |_| | |_) | | | | | (_| | | | | | (_| \__ \
          # |_|\_\___|\__, |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
          #           |___/                             |___/
          # by Stephan Raabe (2023)
          # -----------------------------------------------------

          # -----------------------------------------------------
          # Path to keybindings config file
          # -----------------------------------------------------
          config_file="/home/$USER/.config/hypr/hyprland.conf"
          echo "Reading from: $config_file"

          # -----------------------------------------------------
          # Parse keybindings
          # -----------------------------------------------------
          keybinds=$(grep -oP '(?<=bind=).*' $config_file)
          keybinds=$(echo "$keybinds" | sed 's/$mainMod/SUPER/g'|  sed 's/,\([^,]*\)$/ = \1/' | sed 's/, exec//g' | sed 's/^,//g')

          # -----------------------------------------------------
          # Show keybindings in rofi
          # -----------------------------------------------------
          # rofi -dmenu -i -replace -p "Keybinds" -config ~/dotfiles/rofi/config-compact.rasi <<< "$keybinds"
          rofi -dmenu -i -replace -p "Keybinds" <<< "$keybinds"
        '';
      };
      "hypr/monitor.conf".text = let
        inherit (h) primaryScale;
      in
        l.concatStringsSep "\n" [
          "monitor=HDMI-A-1,preferred,auto,1,mirror,eDP-1"
          "monitor=,highres,auto,${primaryScale}"
          "$mainMod = SUPER"
          ''
            bind = $mainMod, P, exec, hyprctl keyword monitor "eDP-1,1280x720,auto,1"''
          ''
            bind = $mainMod SHIFT, P, exec, hyprctl keyword monitor "eDP-1,highres,auto,${primaryScale}"''
          ''
            bindl = , switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, highres, auto, ${primaryScale}"''
          ''
            bindl = , switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"''
        ];
      "hypr/screenshot.sh" = {
        executable = true;
        source = pkgs.writeShellScript "screenshot.sh" ''
          #  ____                               _           _
          # / ___|  ___ _ __ ___  ___ _ __  ___| |__   ___ | |_
          # \___ \ / __| '__/ _ \/ _ \ '_ \/ __| '_ \ / _ \| __|
          #  ___) | (__| | |  __/  __/ | | \__ \ | | | (_) | |_
          # |____/ \___|_|  \___|\___|_| |_|___/_| |_|\___/ \__|
          #
          #
          # by Stephan Raabe (2023)
          # -----------------------------------------------------

          DIR="$HOME/Pictures/01-Screenshots/"
          NAME="screenshot_$(date +%d%m%Y_%H%M%S).png"

          option2="Selected area"
          option3="Fullscreen (delay 3 sec)"

          options="$option2\n$option3"

          choice=$(echo -e "$options" | ${pkgs.rofi}/bin/rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 2 -width 30 -p "Take Screenshot")

          case $choice in
              $option2)
                  ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
                  notify-send "Screenshot created" "Mode: Selected area"
              ;;
              $option3)
                  sleep 3
                  ${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f -
                  notify-send "Screenshot created" "Mode: Fullscreen"
              ;;
          esac
        '';
      };
      "hypr/toggleallfloat.sh" = {
        executable = true;
        text = ''
          hyprctl dispatch workspaceopt allfloat
        '';
      };
      "hypr/wallpaper.sh" = {
        executable = true;
        source = pkgs.writeShellScript "wallpaper.sh" ''
          pkill hyprpaper
          ${pkgs.hyprpaper}/bin/hyprpaper
        '';
      };
    };
  };
}
