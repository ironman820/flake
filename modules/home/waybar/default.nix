{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt;
  inherit (config.mine.home.user.settings.applications) browser fileManager terminal;

  cfg = config.mine.home.waybar;
in {
  options.mine.home.waybar = {
    enable = mkEnableOption "Enable the module";
    systemd = mkBoolOpt true "Start Waybar with Systemd";
  };
  config = mkIf cfg.enable {
    programs.waybar = {
      inherit (cfg) enable;
      package = inputs.waybar.packages.${pkgs.system}.waybar;
      settings = {
        mainBar = {
          layer = "top";
          margin-top = 14;
          margin-bottom = 0;
          margin-left = 0;
          margin-right = 0;
          spacing = 0;
          modules-left = [
            "custom/appmenuicon"
            "group/hardware"
            "wlr/taskbar"
            "group/quicklinks"
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
              "*" = 3;
            };
          };
          "wlr/taskbar" = {
            format = "{icon}";
            icon-size = 18;
            tooltip-format = "{title}";
            on-click = "activate";
            on-click-middle = "close";
            ignore-list = [
              "Alacritty"
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
          "custom/youtube" = {
            format = " {}";
            exec = "python ~/private/youtube.py";
            restart-interval = 600;
            on-click = "chromium https://studio.youtube.com";
            tooltip = false;
          };
          "custom/cliphist" = {
            format = "";
            on-click = "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh";
            on-click-right = "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh d";
            on-click-middle = "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh w";
            tooltip = false;
          };
          "custom/keybindings" = {
            format = "";
            on-click = "~/dotfiles/hypr/scripts/keybindings.sh";
            tooltip = false;
          };
          "custom/filemanager" = {
            format = "";
            on-click = "${pkgs.${terminal}}/bin/${terminal} -e ${fileManager}";
            tooltip = false;
          };
          "custom/teams" = {
            format = "";
            on-click = "chromium --app=https://teams.microsoft.com/go";
            tooltip = false;
          };
          "custom/browser" = {
            format = "";
            on-click = "${pkgs.${browser}}/bin/${browser}";
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
            format = "{icon}";
            format-icons = {
              locked = "";
              unlocked = "";
            };
          };
          "tray" = {
            icon-size = 21;
            spacing = 10;
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
            on-click = "alacritty -e htop";
          };
          "memory" = {
            interval = 30;
            format = "  {}%";
            format-alt = "  {used:0.1f}G";
            max-length = 10;
            on-click = "alacritty -e htop";
          };
          "disk" = {
            interval = 30;
            format = " {percentage_used}% ";
            path = "/";
            on-click = "alacritty -e htop";
          };

          "group/hardware" = {
            orientation = "inherit";
            "modules" = [
              # "custom/system"
              "disk"
              "cpu"
              "memory"
            ];
          };
          "group/quicklinks" = {
            orientation = "horizontal";
            modules = [
              "custom/browser"
              "custom/filemanager"
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
            # on-click = "~/dotfiles/.settings/networkmanager.sh";
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
            # format-good = ""; # An empty format will hide the module
            # format-full = "";
            format-icons = [" " " " " " " " " "];
          };
          "pulseaudio" = {
            scroll-step = 1; # %, can be a float
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
        /* @import 'style-light.css'; */

        /* -----------------------------------------------------
         * General
         * ----------------------------------------------------- */

        * {
            border: none;
            border-radius: 0px;
        }

        window#waybar {
            border-bottom: 0px solid @base05;
            transition-property: background-color;
            transition-duration: .5s;
        }

        /* -----------------------------------------------------
         * Workspaces
         * ----------------------------------------------------- */

        #workspaces {
            background: @base00;
            margin: 2px 1px 3px 1px;
            padding: 0px 1px;
            border-radius: 15px;
            border: 0px;
            font-weight: bold;
            font-style: normal;
            opacity: 0.8;
            font-size: 16px;
            color: @base00;
        }

        #workspaces button {
            padding: 0px 5px;
            margin: 4px 3px;
            border-radius: 15px;
            border: 0px;
            color: @base00;
            background-color: @base0D;
            transition: all 0.3s ease-in-out;
            opacity: 0.4;
        }

        #workspaces button.active {
            color: @base00;
            background: @base0D;
            border-radius: 15px;
            min-width: 40px;
            transition: all 0.3s ease-in-out;
            opacity:1.0;
        }

        #workspaces button:hover {
            color: @base00;
            background: @base0D;
            border-radius: 15px;
            opacity:0.7;
        }

        /* -----------------------------------------------------
         * Tooltips
         * ----------------------------------------------------- */

        tooltip {
            border-radius: 10px;
            background-color: @base00;
            opacity:0.8;
            padding:20px;
            margin:0px;
        }

        tooltip label {
            color: @base0D;
        }

        /* -----------------------------------------------------
         * Window
         * ----------------------------------------------------- */

        #window {
            background: @base00;
            margin: 5px 15px 5px 0px;
            padding: 2px 10px 0px 10px;
            border-radius: 12px;
            color:@base0D;
            font-size:16px;
            font-weight:normal;
            opacity:0.8;
        }

        window#waybar.empty #window {
            background: alpha(@base00, 0.1);
        }

        /* -----------------------------------------------------
         * Taskbar
         * ----------------------------------------------------- */

        #taskbar {
            background: @base00;
            margin: 3px 15px 3px 0px;
            padding:0px;
            border-radius: 15px;
            font-weight: normal;
            font-style: normal;
            opacity:0.8;
            border: 3px solid @base0D;
        }

        #taskbar button {
            margin:0;
            border-radius: 15px;
            padding: 0px 5px 0px 5px;
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
            margin-right: 23px;
            font-size: 20px;
            font-weight: bold;
            opacity: 0.8;
            color: @base0D;
        }

        #custom-system {
            margin-right:15px;
        }

        #custom-wallpaper {
            margin-right:25px;
        }

        #custom-waybarthemes, #custom-settings {
            margin-right:20px;
        }

        /* -----------------------------------------------------
         * Idle Inhibator
         * ----------------------------------------------------- */

        #idle_inhibitor {
            margin-right: 15px;
            font-size: 22px;
            font-weight: bold;
            opacity: 0.8;
            color: @base0D;
        }

        #idle_inhibitor.activated {
            margin-right: 15px;
            font-size: 20px;
            font-weight: bold;
            opacity: 0.8;
            color: @base08;
        }

        /* -----------------------------------------------------
         * Custom Modules
         * ----------------------------------------------------- */

        #custom-appmenu, #custom-appmenuwlr {
            background-color: @base0D;
            font-size: 16px;
            color: @textcolor1;
            border-radius: 15px;
            padding: 0px 10px 0px 10px;
            margin: 3px 15px 3px 14px;
            opacity:0.8;
            border:3px solid @base00;
        }

        /* -----------------------------------------------------
         * Custom Exit
         * ----------------------------------------------------- */

        #custom-exit {
            margin: 0px 20px 0px 0px;
            padding:0px;
            font-size:20px;
            color: @base0D;
        }

        /* -----------------------------------------------------
         * Hardware Group
         * ----------------------------------------------------- */

        #disk,#memory,#cpu,#language {
            margin:0px;
            font-size:16px;
            color:@base0D;
        }

        #language {
            margin-right:10px;
        }

        /* -----------------------------------------------------
         * Clock
         * ----------------------------------------------------- */

        #clock {
            background-color: @base00;
            font-size: 16px;
            color: @base0D;
            border-radius: 15px;
            margin: 3px 15px 3px 0px;
            opacity:0.8;
            border:3px solid @base0D;
        }

        /* -----------------------------------------------------
         * Pulseaudio
         * ----------------------------------------------------- */

        #pulseaudio {
            background-color: @base00;
            font-size: 16px;
            color: @base0D;
            border-radius: 15px;
            margin: 5px 15px 5px 0px;
            opacity:0.8;
        }

        #pulseaudio.muted {
            background-color: @base0D;
            color: @base00;
        }

        /* -----------------------------------------------------
         * Network
         * ----------------------------------------------------- */

        #network {
            background-color: @base00;
            font-size: 16px;
            color: @base0D;
            border-radius: 15px;
            margin: 5px 15px 5px 0px;
            opacity:0.8;
        }

        #network.ethernet {
            background-color: @base00;
            color: @base0D;
        }

        #network.wifi {
            background-color: @base00;
            color: @base0D;
        }

        /* -----------------------------------------------------
         * Bluetooth
         * ----------------------------------------------------- */

        #bluetooth, #bluetooth.on, #bluetooth.connected {
            background-color: @base00;
            font-size: 16px;
            color: @base0D;
            border-radius: 15px;
            padding: 0 5px;
            margin: 5px 15px 5px 0px;
            opacity:0.8;
        }

        #bluetooth.off {
            background: alpha(@base00, 0.1);
            padding: 0px;
            margin: 0px;
        }

        /* -----------------------------------------------------
         * Battery
         * ----------------------------------------------------- */

        #battery {
            background-color: @base00;
            font-size: 16px;
            color: @base0D;
            border-radius: 15px;
            margin: 5px 15px 5px 0px;
            opacity:0.8;
        }

        #battery.charging, #battery.plugged {
            color: @base0D;
            background-color: @base00;
        }

        @keyframes blink {
            to {
                background-color: @base00;
                color: @base0D;
            }
        }

        #battery.critical:not(.charging) {
            background-color: @base08;
            color: @base0D;
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
            padding: 0 5px;
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
          #!/usr/bin/env bash
          systemctl --user restart waybar
        '';
      };
    };
  };
}
