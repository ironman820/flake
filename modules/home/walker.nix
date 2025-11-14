{
  flake.homeModules.walker = {
    nix.settings = {
      extra-substituters = [
        "https://walker.cachix.org"
        "https://walker-git.cachix.org"
      ];
      extra-trusted-public-keys = [
        "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
        "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
      ];
    };
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        click_to_close = true;
        close_when_open = true;
        disable_mouse = false;
        exact_search_prefix = "'";
        force_keyboard_focus = true;
        global_argument_delimiter = "#";
        keybinds = {
          close = [ "Escape" ];
          next = [ "Down" ];
          previous = [ "Up" ];
          quick_activate = [ ];
          resume_last_query = [ "ctrl r" ];
          toggle_exact = [ "ctrl e" ];
        };
        placeholders = {
          default = {
            input = " Search...";
            list = "No Results";
          };
        };
        providers = {
          actions = {
            archlinuxpkgs = [
              {
                action = "install";
                bind = "Return";
                default = true;
              }
              {
                action = "remove";
                bind = "Return";
              }
            ];
            bluetooth = [
              {
                action = "find";
                after = "AsyncClearReload";
                bind = "ctrl f";
                global = true;
              }
              {
                action = "trust";
                after = "AsyncReload";
                bind = "ctrl t";
              }
              {
                action = "untrust";
                after = "AsyncReload";
                bind = "ctrl t";
              }
              {
                action = "pair";
                after = "AsyncReload";
                bind = "Return";
              }
              {
                action = "remove";
                after = "AsyncReload";
                bind = "ctrl d";
              }
              {
                action = "connect";
                after = "AsyncReload";
                bind = "Return";
              }
              {
                action = "disconnect";
                after = "AsyncReload";
                bind = "Return";
              }
            ];
            calc = [
              {
                action = "copy";
                bind = "Return";
                default = true;
              }
              {
                action = "delete";
                after = "AsyncReload";
                bind = "ctrl d";
              }
              {
                action = "save";
                after = "AsyncClearReload";
                bind = "ctrl s";
              }
            ];
            clipboard = [
              {
                action = "copy";
                bind = "Return";
                default = true;
              }
              {
                action = "remove";
                after = "ClearReload";
                bind = "ctrl d";
              }
              {
                action = "remove_all";
                after = "ClearReload";
                bind = "ctrl shift d";
                global = true;
                label = "clear";
              }
              {
                action = "toggle_images";
                after = "ClearReload";
                bind = "ctrl i";
                global = true;
                label = "toggle images";
              }
              {
                action = "edit";
                bind = "ctrl o";
              }
            ];
            desktopapplications = [
              {
                action = "start";
                bind = "Return";
                default = true;
              }
              {
                action = "start:keep";
                after = "KeepOpen";
                bind = "shift Return";
                label = "open+next";
              }
              {
                action = "erase_history";
                after = "AsyncReload";
                bind = "ctrl h";
                label = "clear hist";
              }
              {
                action = "pin";
                after = "AsyncReload";
                bind = "ctrl p";
              }
              {
                action = "unpin";
                after = "AsyncReload";
                bind = "ctrl p";
              }
              {
                action = "pinup";
                after = "AsyncReload";
                bind = "ctrl n";
              }
              {
                action = "pindown";
                after = "AsyncReload";
                bind = "ctrl m";
              }
            ];
            dmenu = [
              {
                action = "select";
                bind = "Return";
                default = true;
              }
            ];
            files = [
              {
                action = "open";
                bind = "Return";
                default = true;
              }
              {
                action = "opendir";
                bind = "ctrl Return";
                label = "open dir";
              }
              {
                action = "copypath";
                bind = "ctrl shift c";
                label = "copy path";
              }
              {
                action = "copyfile";
                bind = "ctrl c";
                label = "copy file";
              }
            ];
            providerlist = [
              {
                action = "activate";
                after = "ClearReload";
                bind = "Return";
                default = true;
              }
            ];
            runner = [
              {
                action = "run";
                bind = "Return";
                default = true;
              }
              {
                action = "runterminal";
                bind = "shift Return";
                label = "run in terminal";
              }
              {
                action = "erase_history";
                after = "Reload";
                bind = "ctrl h";
                label = "clear hist";
              }
            ];
            symbols = [
              {
                action = "run_cmd";
                bind = "Return";
                default = true;
                label = "select";
              }
              {
                action = "erase_history";
                after = "Reload";
                bind = "ctrl h";
                label = "clear hist";
              }
            ];
            todo = [
              {
                action = "save";
                after = "ClearReload";
                bind = "Return";
                default = true;
              }
              {
                action = "delete";
                after = "ClearReload";
                bind = "ctrl d";
              }
              {
                action = "active";
                after = "ClearReload";
                bind = "Return";
              }
              {
                action = "inactive";
                after = "ClearReload";
                bind = "Return";
              }
              {
                action = "done";
                after = "ClearReload";
                bind = "ctrl f";
              }
              {
                action = "clear";
                after = "ClearReload";
                bind = "ctrl x";
                global = true;
              }
            ];
            unicode = [
              {
                action = "run_cmd";
                bind = "Return";
                default = true;
                label = "select";
              }
              {
                action = "erase_history";
                after = "Reload";
                bind = "ctrl h";
                label = "clear hist";
              }
            ];
            websearch = [
              {
                action = "search";
                bind = "Return";
                default = true;
              }
              {
                action = "erase_history";
                after = "Reload";
                bind = "ctrl h";
                label = "clear hist";
              }
            ];
          };
          default = [
            "desktopapplications"
            "menus"
            "websearch"
          ];
          empty = [ "desktopapplications" ];
          max_results = 50;
          max_results_provider = { };
          prefixes = [
            {
              prefix = "/";
              provider = "providerlist";
            }
            {
              prefix = ".";
              provider = "files";
            }
            {
              prefix = ":";
              provider = "symbols";
            }
            {
              prefix = "=";
              provider = "calc";
            }
            {
              prefix = "@";
              provider = "websearch";
            }
            {
              prefix = "$";
              provider = "clipboard";
            }
          ];
          # sets = «repeated»;
        };
        selection_wrap = true;
        shell = {
          anchor_bottom = true;
          anchor_left = true;
          anchor_right = true;
          anchor_top = true;
        };
        theme = "omanix-tokyo-night";
      };
      themes = {
        "omanix-tokyo-night" = {
          layouts = {
            "layout" = ''
              <?xml version="1.0" encoding="UTF-8"?>
              <interface>
                <requires lib="gtk" version="4.0"></requires>
                <object class="GtkWindow" id="Window">
                  <style>
                    <class name="window"></class>
                  </style>
                  <property name="resizable">true</property>
                  <property name="title">Walker</property>
                  <child>
                    <object class="GtkBox" id="BoxWrapper">
                      <style>
                        <class name="box-wrapper"></class>
                      </style>
                      <property name="width-request">644</property>
                      <property name="overflow">hidden</property>
                      <property name="orientation">horizontal</property>
                      <property name="valign">center</property>
                      <property name="halign">center</property>
                      <child>
                        <object class="GtkBox" id="Box">
                          <style>
                            <class name="box"></class>
                          </style>
                          <property name="orientation">vertical</property>
                          <property name="hexpand-set">true</property>
                          <property name="hexpand">true</property>
                          <property name="spacing">10</property>
                          <child>
                            <object class="GtkBox" id="SearchContainer">
                              <style>
                                <class name="search-container"></class>
                              </style>
                              <property name="overflow">hidden</property>
                              <property name="orientation">horizontal</property>
                              <property name="halign">fill</property>
                              <property name="hexpand-set">true</property>
                              <property name="hexpand">true</property>
                              <child>
                                <object class="GtkEntry" id="Input">
                                  <style>
                                    <class name="input"></class>
                                  </style>
                                  <property name="halign">fill</property>
                                  <property name="hexpand-set">true</property>
                                  <property name="hexpand">true</property>
                                </object>
                              </child>
                            </object>
                          </child>
                          <child>
                            <object class="GtkBox" id="ContentContainer">
                              <style>
                                <class name="content-container"></class>
                              </style>
                              <property name="orientation">horizontal</property>
                              <property name="spacing">10</property>
                              <property name="vexpand">true</property>
                              <property name="vexpand-set">true</property>
                              <child>
                                <object class="GtkLabel" id="ElephantHint">
                                  <style>
                                    <class name="elephant-hint"></class>
                                  </style>
                                  <property name="hexpand">true</property>
                                  <property name="height-request">100</property>
                                  <property name="label">Waiting for elephant...</property>
                                </object>
                              </child>
                              <child>
                                <object class="GtkLabel" id="Placeholder">
                                  <style>
                                    <class name="placeholder"></class>
                                  </style>
                                  <property name="label">No Results</property>
                                  <property name="yalign">0.0</property>
                                  <property name="hexpand">true</property>
                                </object>
                              </child>
                              <child>
                                <object class="GtkScrolledWindow" id="Scroll">
                                  <style>
                                    <class name="scroll"></class>
                                  </style>
                                  <property name="hexpand">true</property>
                                  <property name="can_focus">false</property>
                                  <property name="overlay-scrolling">true</property>
                                  <property name="max-content-width">600</property>
                                  <property name="max-content-height">300</property>
                                  <property name="min-content-height">0</property>
                                  <property name="propagate-natural-height">true</property>
                                  <property name="propagate-natural-width">true</property>
                                  <property name="hscrollbar-policy">automatic</property>
                                  <property name="vscrollbar-policy">automatic</property>
                                  <child>
                                    <object class="GtkGridView" id="List">
                                      <style>
                                        <class name="list"></class>
                                      </style>
                                      <property name="max_columns">1</property>
                                      <property name="can_focus">false</property>
                                    </object>
                                  </child>
                                </object>
                              </child>
                              <child>
                                <object class="GtkBox" id="Preview">
                                  <style>
                                    <class name="preview"></class>
                                  </style>
                                </object>
                              </child>
                            </object>
                          </child>
                          <child>
                            <object class="GtkLabel" id="Error">
                              <style>
                                <class name="error"></class>
                              </style>
                              <property name="xalign">0</property>
                             <property name="visible">false</property>
                            </object>
                          </child>
                        </object>
                      </child>
                    </object>
                  </child>
                </object>
              </interface>
            '';
          };
          style = ''
            @define-color selected-text #7dcfff;
            @define-color text #cfc9c2;
            @define-color base #1a1b26;
            @define-color border #33ccff;
            @define-color foreground #cfc9c2;
            @define-color background #1a1b26;

            * {
              all: unset;
            }

            * {
              font-family: monospace;
              font-size: 18px;
              color: @text;
            }

            scrollbar {
              opacity: 0;
            }

            .normal-icons {
              -gtk-icon-size: 16px;
            }

            .large-icons {
              -gtk-icon-size: 32px;
            }

            .box-wrapper {
              background: alpha(@base, 0.95);
              padding: 20px;
              border: 2px solid @border;
            }

            .preview-box {
            }

            .box {
            }

            .search-container {
              background: @base;
              padding: 10px;
            }

            .input placeholder {
              opacity: 0.5;
            }

            .input {
            }

            .input:focus,
            .input:active {
              box-shadow: none;
              outline: none;
            }

            .content-container {
            }

            .placeholder {
            }

            .scroll {
            }

            .list {
            }

            child,
            child > * {
            }

            child:hover .item-box {
            }

            child:selected .item-box {
            }

            child:selected .item-box * {
              color: @selected-text;
            }

            .item-box {
              padding-left: 14px;
            }

            .item-text-box {
              all: unset;
              padding: 14px 0;
            }

            .item-text {
            }

            .item-subtext {
              font-size: 0px;
              min-height: 0px;
              margin: 0px;
              padding: 0px;
            }

            .item-image {
              margin-right: 14px;
              -gtk-icon-transform: scale(0.9);
            }

            .current {
              font-style: italic;
            }

            .keybind-hints {
              background: @background;
              padding: 10px;
              margin-top: 10px;
            }

            .preview {
              background: @background;
            }
          '';
        };
      };
    };
  };
}
