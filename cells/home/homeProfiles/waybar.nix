{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) ceil toString;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) int;
  inherit (config.mine.home.user.settings.applications) terminal;

  cfg = config.mine.home.waybar;
  imp = config.mine.home.impermanence.enable;
  multiplier = cfg.resolution / 2160.0;
  resolution_multiplier =
    if multiplier < 0.5
    then multiplier * 2
    else multiplier;
in {
  options.mine.home.waybar = {
    enable = mkEnableOption "Enable the module";
    resolution = mkOpt int 2160 "Screen height";
    systemd = mkBoolOpt true "Start Waybar with Systemd";
  };
  config = mkIf cfg.enable {
    home.persistence."/persist/home".directories = mkIf imp [
      ".cache/mesa_shader_cache"
    ];
    programs.waybar = {
      inherit (cfg) enable;
      package = inputs.waybar.packages.${pkgs.system}.waybar;
      settings = {
        mainBar = {
          layer = "top";
          margin-top = 0;
          margin-bottom = 0;
          margin-left = 0;
          margin-right = 0;
          spacing = 0;
          modules-left = [
            "custom/appmenuicon"
            "group/hardware"
            "wlr/taskbar"
            "hyprland/window"
          ];
          modules-center = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "pulseaudio"
            "bluetooth"
            "battery"
            "network"
            "custom/cliphist"
            "idle_inhibitor"
            "tray"
            "custom/exit"
            "clock"
          ];
          "hyprland/workspaces" = {
            on-click = "activate";
            active-only = false;
            all-outputs = false;
            format = "{name}: {icon} ";
            format-icons = {
              "1" = "󰆍";
              "2" = "";
              "3" = "󰑩";
              urgent = "";
              default = "";
            };
            persistent-workspaces = {
              "*" = 1;
            };
          };
          "wlr/taskbar" = {
            format = "{icon}";
            icon-size = ceil (18 * resolution_multiplier);
            tooltip-format = "{title}";
            on-click = "activate";
            on-click-middle = "close";
            ignore-list = [
              "Alacritty"
              "Kitty"
            ];
            app_ids-mapping = {
              firefoxdeveloperedition = "firefox-developer-edition";
            };
            rewrite = {
              "Ablaze Floorp" = "Floorp";
              "Firefox Web Browser" = "Firefox";
              "Foot Server" = "Terminal";
            };
          };
          "hyprland/window" = {
            rewrite = {
              "(.*) - Ablaze Floorp" = "$1";
              "(.*) - Brave" = "$1";
              "(.*) - Chromium" = "$1";
              "(.*) - Brave Search" = "$1";
              "(.*) Microsoft Teams" = "$1";
            };
            separate-outputs = true;
          };
          "custom/cliphist" = {
            format = "";
            on-click = "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh";
            on-click-right = "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh d";
            on-click-middle = "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh w";
            tooltip = false;
          };
          "custom/empty" = {
            format = "";
          };
          "custom/keybindings" = {
            format = "";
            on-click = "~/dotfiles/hypr/scripts/keybindings.sh";
            tooltip = false;
          };
          "custom/calculator" = {
            format = "";
            on-click = "qalculate-gtk";
            tooltip = false;
          };
          "custom/appmenu" = {
            format = "Apps";
            on-click = "rofi -show drun -replace";
            on-click-right = "~/.config/hypr/keybindings.sh";
            tooltip = false;
          };
          "custom/appmenuicon" = {
            format = "";
            on-click = "rofi -show drun -replace";
            on-click-right = "~/.config/hypr/keybindings.sh";
            tooltip = false;
          };
          "custom/exit" = {
            format = "";
            on-click = "wlogout";
            tooltip = false;
          };
          "keyboard-state" = {
            numlock = false;
            capslock = true;
            interval = 5;
            format = "{name} {icon}";
            format-icons = {
              locked = "";
              unlocked = "";
            };
          };
          "tray" = {
            icon-size = ceil (21 * resolution_multiplier);
            spacing = ceil (10 * resolution_multiplier);
          };
          "clock" = {
            timezone = "America/Chicago";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          "custom/system" = {
            format = "󱎴";
            tooltip = false;
          };
          "cpu" = {
            interval = 10;
            format = "  {}%";
            max-length = 10;
            on-click = "${terminal} -e htop";
          };
          "memory" = {
            interval = 30;
            format = "  {}%";
            format-alt = "  {used:0.1f}G";
            max-length = 10;
            on-click = "${terminal} -e htop";
          };
          "disk" = {
            interval = 30;
            format = " {percentage_used}% ";
            path = "/";
            on-click = "${terminal} -e htop";
          };

          "group/hardware" = {
            orientation = "inherit";
            "modules" = [
              "custom/system"
              "disk"
              "cpu"
              "memory"
            ];
          };
          "network" = {
            format = "{ifname}";
            format-wifi = " {signalStrength}%";
            format-ethernet = "󰈀 {ifname}";
            format-disconnected = "Disconnected";
            tooltip-format = "󰈀 {ifname} via {gwaddri}";
            tooltip-format-wifi = " {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\nUp: {bandwidthUpBits} Down: {bandwidthDownBits}";
            tooltip-format-ethernet = "󰈀 {ifname}\nIP: {ipaddr}\n up: {bandwidthUpBits} down: {bandwidthDownBits}";
            tooltip-format-disconnected = "Disconnected";
            max-length = 50;
          };
          "battery" = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-alt = "{icon} {time}";
            format-icons = [" " " " " " " " " "];
          };
          "pulseaudio" = {
            # scroll-step = 1; # %, can be a float
            format = "{icon} {volume}%";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "婢 {icon} {format_source}";
            format-muted = "婢 {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" " " " "];
            };
            on-click = "pavucontrol";
          };
          "bluetooth" = {
            format = " {status}";
            format-disabled = "";
            format-off = "";
            interval = 30;
            on-click = "blueman-manager";
          };
          "user" = {
            format = "{user}";
            interval = 60;
            icon = false;
          };
          "idle_inhibitor" = {
            format = "{icon}";
            tooltip = true;
            format-icons = {
              activated = " ";
              deactivated = " ";
            };
            on-click-right = "hyprlock";
          };
        };
      };
      style = ''
        /*
         * __        __          _                  ____  _         _
         * \ \      / /_ _ _   _| |__   __ _ _ __  / ___|| |_ _   _| | ___
         *  \ \ /\ / / _` | | | | '_ \ / _` | '__| \___ \| __| | | | |/ _ \
         *   \ V  V / (_| | |_| | |_) | (_| | |     ___) | |_| |_| | |  __/
         *    \_/\_/ \__,_|\__, |_.__/ \__,_|_|    |____/ \__|\__, |_|\___|
         *                 |___/                              |___/
         *
         * by Stephan Raabe (2023)
         * -----------------------------------------------------
        */

        /* -----------------------------------------------------
         * Import Pywal colors
         * ----------------------------------------------------- */
        @define-color backgroundlight #FFFFFF;
        @define-color backgrounddark #FFFFFF;
        @define-color workspacesbackground1 #FFFFFF;
        @define-color workspacesbackground2 #CCCCCC;
        @define-color bordercolor #FFFFFF;
        @define-color textcolor1 #000000;
        @define-color textcolor2 #000000;
        @define-color textcolor3 #000000;
        @define-color iconcolor #FFFFFF;


        /* -----------------------------------------------------
         * General
         * ----------------------------------------------------- */

        * {
            border: none;
            border-radius: 0px;
        }

        window#waybar {
            background-color: rgba(0,0,0,0.2);
            border-bottom: 0px solid #ffffff;
            transition-property: background-color;
            transition-duration: .5s;
        }

        /* -----------------------------------------------------
         * Workspaces
         * ----------------------------------------------------- */

        #workspaces {
            background: @workspacesbackground1;
            margin: ${toString (ceil (5 * resolution_multiplier))}px ${toString (ceil (1 * resolution_multiplier))}px ${toString (ceil (6 * resolution_multiplier))}px ${toString (ceil (1 * resolution_multiplier))}px;
            padding: 0px ${toString (ceil (1 * resolution_multiplier))}px;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            border: 0px;
            font-weight: bold;
            font-style: normal;
            opacity: 0.8;
            font-size: ${toString (ceil (16 * resolution_multiplier))}px;
            color: @textcolor1;
        }

        #workspaces button {
            padding: 0px ${toString (ceil (5 * resolution_multiplier))}px;
            margin: ${toString (ceil (4 * resolution_multiplier))}px ${toString (ceil (3 * resolution_multiplier))}px;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            border: 0px;
            color: @textcolor1;
            background-color: @workspacesbackground2;
            transition: all 0.3s ease-in-out;
            opacity: 0.4;
        }

        #workspaces button.active {
            color: @textcolor1;
            background: @workspacesbackground2;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            min-width: ${toString (ceil (40 * resolution_multiplier))}px;
            transition: all 0.3s ease-in-out;
            opacity:1.0;
        }

        #workspaces button:hover {
            color: @textcolor1;
            background: @workspacesbackground2;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            opacity:0.7;
        }

        /* -----------------------------------------------------
         * Tooltips
         * ----------------------------------------------------- */

        tooltip {
            border-radius: ${toString (ceil (10 * resolution_multiplier))}px;
            background-color: @backgroundlight;
            opacity:0.8;
            padding:${toString (ceil (20 * resolution_multiplier))}px;
            margin:0px;
        }

        tooltip label {
            color: @textcolor2;
        }

        /* -----------------------------------------------------
         * Window
         * ----------------------------------------------------- */

        #window {
            background: @backgroundlight;
            margin: ${toString (ceil (8 * resolution_multiplier))}px ${toString (ceil (15 * resolution_multiplier))}px ${toString (ceil (8 * resolution_multiplier))}px 0px;
            padding: ${toString (ceil (2 * resolution_multiplier))}px ${toString (ceil (10 * resolution_multiplier))}px 0px ${toString (ceil (10 * resolution_multiplier))}px;
            border-radius: ${toString (ceil (12 * resolution_multiplier))}px;
            color:@textcolor2;
            font-size:${toString (ceil (16 * resolution_multiplier))}px;
            font-weight:normal;
            opacity:0.8;
        }

        window#waybar.empty #window {
            background-color: transparent;
        }

        /* -----------------------------------------------------
         * Taskbar
         * ----------------------------------------------------- */

        #taskbar {
            background: @backgroundlight;
            margin: ${toString (ceil (6 * resolution_multiplier))}px ${toString (ceil (15 * resolution_multiplier))}px ${toString (ceil (6 * resolution_multiplier))}px 0px;
            padding:0px;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            font-weight: normal;
            font-style: normal;
            opacity:0.8;
            border: ${toString (ceil (3 * resolution_multiplier))}px solid @backgroundlight;
        }

        #taskbar button {
            margin:0;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            padding: 0px ${toString (ceil (5 * resolution_multiplier))}px 0px ${toString (ceil (5 * resolution_multiplier))}px;
        }

        /* -----------------------------------------------------
         * Modules
         * ----------------------------------------------------- */

        .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
        }

        .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
        }

        /* -----------------------------------------------------
         * Custom Quicklinks
         * ----------------------------------------------------- */

        #custom-appmenuicon,
        #custom-brave,
        #custom-browser,
        #custom-keybindings,
        #custom-outlook,
        #custom-filemanager,
        #custom-teams,
        #custom-chatgpt,
        #custom-calculator,
        #custom-windowsvm,
        #custom-cliphist,
        #custom-wallpaper,
        #custom-settings,
        #custom-wallpaper,
        #custom-system,
        #custom-waybarthemes,
        #keyboard-state {
            margin-right: ${toString (ceil (23 * resolution_multiplier))}px;
            font-size: ${toString (ceil (20 * resolution_multiplier))}px;
            font-weight: bold;
            opacity: 0.8;
            color: @iconcolor;
        }

        #custom-system {
            margin-right:${toString (ceil (15 * resolution_multiplier))}px;
        }

        #custom-wallpaper {
            margin-right:${toString (ceil (25 * resolution_multiplier))}px;
        }

        #custom-waybarthemes, #custom-settings {
            margin-right:${toString (ceil (20 * resolution_multiplier))}px;
        }

        /* -----------------------------------------------------
         * Idle Inhibator
         * ----------------------------------------------------- */

        #idle_inhibitor {
            margin-right: ${toString (ceil (17 * resolution_multiplier))}px;
            font-size: ${toString (ceil (20 * resolution_multiplier))}px;
            font-weight: bold;
            opacity: 0.8;
            color: @iconcolor;
        }

        #idle_inhibitor.activated {
            margin-right: ${toString (ceil (15 * resolution_multiplier))}px;
            font-size: ${toString (ceil (20 * resolution_multiplier))}px;
            font-weight: bold;
            opacity: 0.8;
            color: #dc2f2f;
        }

        /* -----------------------------------------------------
         * Custom Modules
         * ----------------------------------------------------- */

        #custom-appmenu, #custom-appmenuwlr {
            background-color: @backgrounddark;
            font-size: ${toString (ceil (16 * resolution_multiplier))}px;
            color: @textcolor1;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            padding: 0px ${toString (ceil (10 * resolution_multiplier))}px 0px ${toString (ceil (10 * resolution_multiplier))}px;
            margin: ${toString (ceil (8 * resolution_multiplier))}px ${toString (ceil (14 * resolution_multiplier))}px ${toString (ceil (8 * resolution_multiplier))}px ${toString (ceil (14 * resolution_multiplier))}px;
            opacity:0.8;
            border:${toString (ceil (3 * resolution_multiplier))}px solid @bordercolor;
        }

        /* -----------------------------------------------------
         * Custom Exit
         * ----------------------------------------------------- */

        #custom-exit {
            margin: 0px ${toString (ceil (20 * resolution_multiplier))}px 0px 0px;
            padding:0px;
            font-size:${toString (ceil (20 * resolution_multiplier))}px;
            color: @iconcolor;
        }

        /* -----------------------------------------------------
         * Hardware Group
         * ----------------------------------------------------- */

        #disk,#memory,#cpu,#language {
            margin:0px;
            font-size:${toString (ceil (16 * resolution_multiplier))}px;
            color:@iconcolor;
        }

        #language {
            margin-right:${toString (ceil (10 * resolution_multiplier))}px;
        }

        /* -----------------------------------------------------
         * Clock
         * ----------------------------------------------------- */

        #clock {
            background-color: @backgrounddark;
            font-size: ${toString (ceil (16 * resolution_multiplier))}px;
            color: @textcolor1;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            padding: ${toString (ceil (1 * resolution_multiplier))}px ${toString (ceil (10 * resolution_multiplier))}px 0px ${toString (ceil (10 * resolution_multiplier))}px;
            margin: ${toString (ceil (8 * resolution_multiplier))}px ${toString (ceil (15 * resolution_multiplier))}px ${toString (ceil (8 * resolution_multiplier))}px 0px;
            opacity:0.8;
            border:${toString (ceil (3 * resolution_multiplier))}px solid @bordercolor;
        }

        /* -----------------------------------------------------
         * Pulseaudio
         * ----------------------------------------------------- */

        #pulseaudio {
            background-color: @backgrounddark;
            font-size: ${toString (ceil (16 * resolution_multiplier))}px;
            color: @textcolor2;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            padding: ${toString (ceil (2 * resolution_multiplier))}px ${toString (ceil (10 * resolution_multiplier))}px 0px ${toString (ceil (10 * resolution_multiplier))}px;
            margin: ${toString (ceil (8 * resolution_multiplier))}px ${toString (ceil (15 * resolution_multiplier))}px ${toString (ceil (8 * resolution_multiplier))}px 0px;
            opacity:0.8;
        }

        #pulseaudio.muted {
            background-color: @backgrounddark;
            color: @textcolor1;
        }

        /* -----------------------------------------------------
         * Network
         * ----------------------------------------------------- */

        #network {
            background-color: @backgroundlight;
            font-size: ${toString (ceil (16 * resolution_multiplier))}px;
            color: @textcolor2;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            padding: ${toString (ceil (2 * resolution_multiplier))}px ${toString (ceil (10 * resolution_multiplier))}px 0px ${toString (ceil (10 * resolution_multiplier))}px;
            margin: ${toString (ceil (8 * resolution_multiplier))}px ${toString (ceil (15 * resolution_multiplier))}px ${toString (ceil (8 * resolution_multiplier))}px 0px;
            opacity:0.8;
        }

        #network.ethernet {
            background-color: @backgroundlight;
            color: @textcolor2;
        }

        #network.wifi {
            background-color: @backgroundlight;
            color: @textcolor2;
        }

        /* -----------------------------------------------------
         * Bluetooth
         * ----------------------------------------------------- */

        #bluetooth, #bluetooth.on, #bluetooth.connected {
            background-color: @backgroundlight;
            font-size: ${toString (ceil (16 * resolution_multiplier))}px;
            color: @textcolor2;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            padding: ${toString (ceil (2 * resolution_multiplier))}px ${toString (ceil (10 * resolution_multiplier))}px 0px ${toString (ceil (10 * resolution_multiplier))}px;
            margin: ${toString (ceil (8 * resolution_multiplier))}px ${toString (ceil (15 * resolution_multiplier))}px ${toString (ceil (8 * resolution_multiplier))}px 0px;
            opacity:0.8;
        }

        #bluetooth.off {
            background: transparent;
            padding: 0px;
            margin: 0px;
        }

        /* -----------------------------------------------------
         * Battery
         * ----------------------------------------------------- */

        #battery {
            background-color: @backgroundlight;
            font-size: ${toString (ceil (16 * resolution_multiplier))}px;
            color: @textcolor2;
            border-radius: ${toString (ceil (15 * resolution_multiplier))}px;
            padding: ${toString (ceil (2 * resolution_multiplier))}px ${toString (ceil (10 * resolution_multiplier))}px 0px ${toString (ceil (10 * resolution_multiplier))}px;
            margin: ${toString (ceil (8 * resolution_multiplier))}px ${toString (ceil (15 * resolution_multiplier))}px ${toString (ceil (8 * resolution_multiplier))}px 0px;
            opacity:0.8;
        }

        #battery.charging, #battery.plugged {
            color: @textcolor2;
            background-color: @backgroundlight;
        }

        @keyframes blink {
            to {
                background-color: @backgroundlight;
                color: @textcolor2;
            }
        }

        #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: @textcolor3;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        /* -----------------------------------------------------
         * Tray
         * ----------------------------------------------------- */

        #tray {
            padding: 0px ${toString (ceil (15 * resolution_multiplier))}px 0px 0px;
            color: @textcolor3;
        }

        #tray > .passive {
            -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
            -gtk-icon-effect: highlight;
        }


      '';
      systemd = {
        enable = cfg.systemd;
        target = "hyprland-session.target";
      };
    };
    xdg.configFile = {
      "waybar/restart.sh" = {
        executable = true;
        source = pkgs.writeShellScript "restart.sh" ''
          systemctl --user restart waybar
        '';
      };
    };
  };
}
