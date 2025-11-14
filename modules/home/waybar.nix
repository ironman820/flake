{
  flake.homeModules.waybar =
    { config, ... }:
    {
      programs.waybar = {
        enable = true;
        settings = [
        {
          reload_style_on_change = true;
          layer = "top";
          position = "top";
          spacing = 0;
          height = 26;
          modules-left = [
            "custom/omanix"
            "hyprland/workspaces"
          ];
          modules-center = [
            "clock"
            "custom/update"
            "custom/screenrecording-indicator"
          ];
          modules-right = [
            "group/tray-expander"
            "bluetooth"
            "pulseaudio"
            "cpu"
            "battery"
          ];
          "hyprland/workspaces" = {
            on-click = "activate";
            format = "{icon}";
            format-icons = {
              default = "";
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              active = "󱓻";
            };
            persistent-workspaces = {
              "1" = [ ];
              "2" = [ ];
              "3" = [ ];
              "4" = [ ];
              "5" = [ ];
            };
          };
          "custom/omanix" = {
            format = "❄️";
            on-click = "omanix-menu";
            on-click-right = "omarchy-launch-terminal";
            tooltip-format = "Omanix Menu\n\nSuper + Alt + Space";
          };
          "custom/update" = {
            format = "";
            exec = "omarchy-update-available";
            on-click = "omarchy-launch-floating-terminal-with-presentation omarchy-update";
            tooltip-format = "Omarchy update available";
            signal = 7;
            interval = 3600;
          };

          cpu = {
            interval = 5;
            format = "󰍛";
            on-click = "$TERMINAL -e btop";
          };
          clock = {
            format = "{:L%A %H:%M}";
            format-alt = "{:L%d %B W%V %Y}";
            tooltip = false;
            on-click-right = "omarchy-launch-floating-terminal-with-presentation omarchy-tz-select";
          };
          battery = {
            format = "{capacity}% {icon}";
            format-discharging = "{icon}";
            format-charging = "{icon}";
            format-plugged = "";
            format-icons = {
              charging = [
                "󰢜"
                "󰂆"
                "󰂇"
                "󰂈"
                "󰢝"
                "󰂉"
                "󰢞"
                "󰂊"
                "󰂋"
                "󰂅"
              ];
              default = [
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
            };
            format-full = "󰂅";
            tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
            tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
            interval = 5;
            on-click = "omarchy-menu power";
            states = {
              warning = 20;
              critical = 10;
            };
          };
          bluetooth = {
            format = "";
            format-disabled = "󰂲";
            format-connected = "";
            tooltip-format = "Devices connected: {num_connections}";
            on-click = "blueberry";
          };
          pulseaudio = {
            format = "{icon}";
            on-click = "$TERMINAL --class=Wiremix -e wiremix";
            on-click-right = "pamixer -t";
            tooltip-format = "Playing at {volume}%";
            scroll-step = 5;
            format-muted = "";
            format-icons = {
              default = [
                ""
                ""
                ""
              ];
            };
          };
          "group/tray-expander" = {
            orientation = "inherit";
            drawer = {
              transition-duration = 600;
              children-class = "tray-group-item";
            };
            modules = [
              "custom/expand-icon"
              "tray"
            ];
          };
          "custom/expand-icon" = {
            format = "";
            tooltip = false;
          };
          "custom/screenrecording-indicator" = {
            on-click = "omarchy-cmd-screenrecord";
            exec = "$OMARCHY_PATH/default/waybar/indicators/screen-recording.sh";
            signal = 8;
            return-type = "json";
          };
          tray = {
            icon-size = 12;
            spacing = 17;
          };
        }
        ];
        style = ''
          @import "${config.xdg.configHome}/omarchy/current/theme/waybar.css";

          * {
            background-color: @background;
            color: @foreground;

            border: none;
            border-radius: 0;
            min-height: 0;
            font-family: 'CaskaydiaMono Nerd Font';
            font-size: 12px;
          }

          .modules-left {
            margin-left: 8px;
          }

          .modules-right {
            margin-right: 8px;
          }

          #workspaces button {
            all: initial;
            padding: 0 6px;
            margin: 0 1.5px;
            min-width: 9px;
          }

          #workspaces button.empty {
            opacity: 0.5;
          }

          #cpu,
          #battery,
          #pulseaudio,
          #custom-omarchy,
          #custom-screenrecording-indicator,
          #custom-update {
            min-width: 12px;
            margin: 0 7.5px;
          }

          #tray {
            margin-right: 16px;
          }

          #bluetooth {
            margin-right: 17px;
          }

          #network {
            margin-right: 13px;
          }

          #custom-expand-icon {
            margin-right: 20px;
          }

          tooltip {
            padding: 2px;
          }

          #custom-update {
            font-size: 10px;
          }

          #clock {
            margin-left: 8.75px;
          }

          .hidden {
            opacity: 0;
          }

          #custom-screenrecording-indicator {
            min-width: 12px;
            margin-left: 8.75px;
            font-size: 10px;
          }

          #custom-screenrecording-indicator.active {
            color: #a55555;
          }
        '';
        systemd.enable = true;
      };
      xdg.configFile."omarchy/current/theme/waybar.css".text = ''
        @define-color foreground #cdd6f4;
        @define-color background #1a1b26;
      '';
    };
}
