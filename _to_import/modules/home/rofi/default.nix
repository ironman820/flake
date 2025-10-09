{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine.home.user.settings.applications) terminal;
  inherit (lib) mkDefault mkEnableOption mkIf;

  cfg = config.mine.home.rofi;
in {
  options.mine.home.rofi = {enable = mkEnableOption "Setup rofi";};

  config = mkIf cfg.enable {
    programs.rofi = {
      inherit (cfg) enable;
      configPath = "/home/${config.mine.home.user.name}/.config/rofi/default.rasi";
      extraConfig = {
        modi = "drun,run";
        show-icons = true;
        iron-theme = "kora";
        display-drun = "APPS";
        display-run = "RUN";
        display-filebrowser = "FILES";
        drun-display-format = "{name}";
        hover-select = true;
        window-format = "{w} · {c} · {t}";
      };
      font = mkDefault "FiraCode Nerd Font Mono";
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.${terminal}}/bin/${terminal}";
      # theme = mkDefault "${pkgs.catppuccin-rofi}/catppuccin-mocha.rasi";
    };
    xdg.configFile = {
      "rofi/cliphist.sh" = {
        executable = true;
        source = pkgs.writeShellScript "cliphist.sh" ''
          #!/usr/bin/env bash
          #   ____ _ _       _     _     _
          #  / ___| (_)_ __ | |__ (_)___| |_
          # | |   | | | '_ \| '_ \| / __| __|
          # | |___| | | |_) | | | | \__ \ |_
          #  \____|_|_| .__/|_| |_|_|___/\__|
          #           |_|
          #
          # by Stephan Raabe (2023)
          # -----------------------------------------------------

          case $1 in
              d) cliphist list | rofi -dmenu -replace -config ~/.config/rofi/config-cliphist.rasi | cliphist delete
                 ;;

              w) if [ `echo -e "Clear\nCancel" | rofi -dmenu -config ~/.config/rofi/config-short.rasi` == "Clear" ] ; then
                      cliphist wipe
                 fi
                 ;;

              *) cliphist list | rofi -dmenu -replace -config ~/.config/rofi/config-cliphist.rasi | cliphist decode | wl-copy
                 ;;
          esac
        '';
      };
      "rofi/border.rasi".text = ''
        * { border-width: 3px; }
      '';
      "rofi/button.rasi".text = ''
        button {
            padding:                      10px;
            border-radius:                10px;
            /*background-color:             @background;*/
            /*text-color:                   inherit;*/
            cursor:                       pointer;
            border:                       0px;
        }

      '';
      "rofi/config.rasi".text = ''
        /*
        #  ____        __ _
        # |  _ \ ___  / _(_)
        # | |_) / _ \| |_| |
        # |  _ < (_) |  _| |
        # |_| \_\___/|_| |_|
        #
        # by Stephan Raabe (2023)
        # -----------------------------------------------------
        */

        @import "~/.config/rofi/default.rasi"
        @import "~/.config/rofi/sections.rasi"

        /* ---- Window ---- */
        window {
            width:                        900px;
            x-offset:                     0px;
            y-offset:                     0px;
            location:                     center;
            anchor:                       center;
        }

        /* ---- Mainbox ---- */
          mainbox {
            children:                     ["imagebox","listbox"];
          }

        /* ---- Imagebox ---- */

        /* ---- Listbox ---- */
        listbox {
            children:                    [ "message", "listview" ];
        }

        /* ---- Inputbar ---- */
        inputbar {
            border-radius:                10px;
        }

        listview {
            lines:                        8;
        }
        element {
            border:                       @border-width;
          }
      '';
      "rofi/config-cliphist.rasi".text = ''
        @import "~/.config/rofi/default.rasi"
        @import "~/.config/rofi/sections.rasi"

        window {
            width: 400px;
            x-offset: -14px;
            y-offset: 65px;
            location: northeast;
            anchor: northeast;
          }

        mainbox {
          children:                     ["listbox"];
        }
        listbox {
            children: ["inputbar","message","listview"];
          }
        inputbar {
            border-radius: 0;
          }
        listview {
            lines:                        8;
        }
        element {
            border:                       @border-width;
          }
      '';
      "rofi/config-screenshot.rasi".text = ''
        /*
        #  ____        __ _
        # |  _ \ ___  / _(_)
        # | |_) / _ \| |_| |
        # |  _ < (_) |  _| |
        # |_| \_\___/|_| |_|
        #
        # by Stephan Raabe (2023)
        # -----------------------------------------------------
        */

        /* ---- Configuration ---- */
        @import "~/.config/rofi/default.rasi"
        @import "~/.config/rofi/sections.rasi"

        /* ---- Window ---- */
        window {
            width:                        400px;
            x-offset:                     0px;
            y-offset:                     0px;
            location:                     center;
            anchor:                       center;
        }

        /* ---- Mainbox ---- */
        mainbox {
            children:                     ["listbox"];
        }
        /* ---- Listbox ---- */
        listbox {
            children:                    [ "listview" ];
        }

        /* ---- Inputbar ---- */
        inputbar {
            border-radius:                0px;
        }

        /* ---- Listview ---- */
        listview {
            lines:                        2;
        }

        /* ---- Element ---- */
        element {
            border:                       2px;
        }
      '';
      "rofi/config-short.rasi".text = ''
        @import "~/.config/rofi/default.rasi"
        @import "~/.config/rofi/sections.rasi"

        /* ---- Window ---- */
        window {
            width:                        200px;
            height:                       130px;
            x-offset:                     -14px;
            y-offset:                     65px;
            location:                     northeast;
            anchor:                       northeast;
        }

        /* ---- Mainbox ---- */
        mainbox {
            children:                     ["listbox"];
        }

        /* ---- Listbox ---- */
        listbox {
            children:                    [ "listview" ];
        }

        /* ---- Inputbar ---- */
        inputbar {
            border-radius:                0px;
        }

        /* ---- Listview ---- */
        listview {
            lines:                        2;
        }
      '';
      "rofi/element.rasi".text = ''
        /* ---- Element ---- */
        element {
            enabled:                      true;
            padding:                      10px;
            margin:                       5px;
            cursor:                       pointer;
            /*background-color:             @background;*/
            border-radius:                10px;
        }

        element normal.normal {
            /*background-color:            inherit;*/
            /*text-color:                  @foreground;*/
        }

        element normal.urgent {
            /*background-color:            inherit;*/
            /*text-color:                  @foreground;*/
        }

        element normal.active {
            /*background-color:            inherit;*/
            /*text-color:                  @foreground;*/
        }

        element selected.normal {
            /*background-color:            @color11;*/
            /*text-color:                  @foreground;*/
        }

        element selected.urgent {
            /*background-color:            inherit;*/
            /*text-color:                  @foreground;*/
        }

        element selected.active {
            /*background-color:            inherit;*/
            /*text-color:                  @foreground;*/
        }

        element alternate.normal {
            /*background-color:            inherit;*/
            /*text-color:                  @foreground;*/
        }

        element alternate.urgent {
            /*background-color:            inherit;*/
            /*text-color:                  @foreground;*/
        }

        element alternate.active {
            /*background-color:            inherit;*/
            /*text-color:                  @foreground;*/
        }

        element-icon {
            /*background-color:            transparent;*/
            /*text-color:                  inherit;*/
            size:                        32px;
            cursor:                      inherit;
        }

        element-text {
            /*background-color:            transparent;*/
            /*text-color:                  inherit;*/
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.0;
        }
      '';
      "rofi/entry.rasi".text = ''
        entry {
            enabled:                      true;
            /*background-color:             transparent;*/
            /*text-color:                   inherit;*/
            cursor:                       text;
            placeholder:                  "Search";
            /*placeholder-color:            inherit;*/
        }
      '';

      "rofi/imagebox.rasi".text = ''
        imagebox {
            padding:                      18px;
            /*background-color:             transparent;*/
            orientation:                  vertical;
            children:                     [ "inputbar", "dummy", "mode-switcher" ];
        }
      '';
      "rofi/inputbar.rasi".text = ''
        inputbar {
          enabled:                      true;
          /*text-color:                   @foreground;*/
          spacing:                      10px;
          padding:                      15px;
          /*border-color:                 @foreground;*/
          /*background-color:             @background;*/
          children:                     [ "textbox-prompt-colon", "entry" ];
        }
      '';
      "rofi/listbox.rasi".text = ''
        listbox {
            spacing:                     20px;
            /*background-color:            transparent;*/
            orientation:                 vertical;
          }
      '';
      "rofi/listview.rasi".text = ''
        /* ---- Listview ---- */
        listview {
            enabled:                      true;
            columns:                      1;
            cycle:                        true;
            dynamic:                      true;
            scrollbar:                    false;
            layout:                       vertical;
            reverse:                      false;
            fixed-height:                 true;
            fixed-columns:                true;
            spacing:                      0px;
            padding:                      10px;
            margin:                       0px;
            /*background-color:             @background;*/
            border:0px;
        }

      '';
      "rofi/mainbox.rasi".text = ''
        mainbox {
            enabled:                      true;
            orientation:                  horizontal;
            spacing:                      0px;
            margin:                       0px;
            /*background-color:             @background;*/
            /*background-image:             @current-image;*/
        }
      '';
      "rofi/message.rasi".text = ''
        /*****----- Message -----*****/
        message {
            /*background-color:            transparent;*/
            border:0px;
            margin:20px 0px 0px 0px;
            padding:0px;
            spacing:0px;
            border-radius: 10px;
        }

        error-message {
            padding:                     15px;
            border-radius:               20px;
            /*background-color:            @background;*/
            /*text-color:                  @foreground;*/
        }
      '';
      "rofi/mode-switcher.rasi".text = ''
        /* ---- Mode Switcher ---- */
        mode-switcher{
            enabled:                      true;
            spacing:                      20px;
        }

      '';
      "rofi/sections.rasi".text = ''
        @import "~/.config/rofi/border.rasi"
        @import "~/.config/rofi/window.rasi"
        @import "~/.config/rofi/mainbox.rasi"
        @import "~/.config/rofi/imagebox.rasi"
        @import "~/.config/rofi/listbox.rasi"
        @import "~/.config/rofi/inputbar.rasi"
        @import "~/.config/rofi/textbox-prompt-colon.rasi"
        @import "~/.config/rofi/entry.rasi"
        @import "~/.config/rofi/mode-switcher.rasi"
        @import "~/.config/rofi/button.rasi"
        @import "~/.config/rofi/listview.rasi"
        @import "~/.config/rofi/element.rasi"
        @import "~/.config/rofi/message.rasi"
        @import "~/.config/rofi/textbox.rasi"
      '';
      "rofi/textbox.rasi".text = ''
        textbox {
            padding:                     15px;
            margin:                      0px;
            border-radius:               0px;
            /*background-color:            @background;*/
            /*text-color:                  @foreground;*/
            vertical-align:              0.5;
            horizontal-align:            0.0;
        }
      '';
      "rofi/textbox-prompt-colon.rasi".text = ''
        textbox-prompt-colon {
            enabled:                      true;
            expand:                       false;
            str:                          "";
            /*background-color:             transparent;*/
            /*text-color:                   inherit;*/
        }
      '';
      "rofi/window.rasi".text = ''
        /* ---- Window ---- */
        window {
            spacing:                      0px;
            padding:                      0px;
            margin:                       0px;
            /*color:                        #FFFFFF;*/
            border:                       @border-width;
            /*border-color:                 #FFFFFF;*/
            cursor:                       "default";
            /*transparency:                 "real";*/
            fullscreen:                   false;
            enabled:                      true;
            border-radius:                10px;
            /*background-color:             transparent;*/
        }
      '';
    };
  };
}
