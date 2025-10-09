{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.wlogout;
in {
  options.mine.home.wlogout = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    programs.wlogout = {
      inherit (cfg) enable;
      layout = [
        {
          label = "lock";
          action = "sleep 1; hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "hibernate";
          action = "sleep 1; systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "logout";
          action = "sleep 1; hyprctl dispatch exit";
          text = "Exit";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "sleep 1; systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "sleep 1; systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "reboot";
          action = "sleep 1; systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
    };
    xdg.configFile = {
      "wlogout/style.css".text = ''
        /*
                  _                         _
        __      _| | ___   __ _  ___  _   _| |_
        \ \ /\ / / |/ _ \ / _` |/ _ \| | | | __|
         \ V  V /| | (_) | (_| | (_) | |_| | |_
          \_/\_/ |_|\___/ \__, |\___/ \__,_|\__|
                          |___/

        by Stephan Raabe (2023)
        -----------------------------------------------------
        */
        @define-color base00 #1e1e2e; @define-color base01 #181825; @define-color base02 #313244; @define-color base03 #45475a;
        @define-color base04 #585b70; @define-color base05 #cdd6f4; @define-color base06 #f5e0dc; @define-color base07 #b4befe;

        @define-color base08 #f38ba8; @define-color base09 #fab387; @define-color base0A #f9e2af; @define-color base0B #a6e3a1;
        @define-color base0C #94e2d5; @define-color base0D #89b4fa; @define-color base0E #cba6f7; @define-color base0F #f2cdcd;

        /* -----------------------------------------------------
         * General
         * ----------------------------------------------------- */

        * {
            font-family: "DejaVuSansM Nerd Font";
        	background-image: none;
        	transition: 20ms;
        }

        window {
        	background: rgba(12, 12, 12, 0.1);
        }

        button {
        	color: @base0D;
            font-size:20px;

            background-repeat: no-repeat;
        	background-position: center;
        	background-size: 25%;

        	border-style: solid;
        	background-color: rgba(12, 12, 12, 0.3);
        	border: 3px solid @base0D;

            box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
        }

        button:focus,
        button:active,
        button:hover {
            color: @base0B;
        	background-color: rgba(12, 12, 12, 0.5);
        	border: 3px solid @base0B;
        }

        /*
        -----------------------------------------------------
        Buttons
        -----------------------------------------------------
        */

        #lock {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url("icons/lock.png"));
        }

        #logout {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url("icons/logout.png"));
        }

        #suspend {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url("icons/suspend.png"));
        }

        #hibernate {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url("icons/hibernate.png"));
        }

        #shutdown {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url("icons/shutdown.png"));
        }

        #reboot {
        	margin: 10px;
        	border-radius: 20px;
        	background-image: image(url("icons/reboot.png"));
        }
      '';
      "wlogout/icons".source = ./files/icons;
    };
  };
}
