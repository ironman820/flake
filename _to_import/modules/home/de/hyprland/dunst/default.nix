{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (config.mine.home.user.settings.applications) browser;
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.de.hyprland.dunst;
  os = osConfig.mine.de.hyprland.dunst;
in {
  options.mine.home.de.hyprland.dunst = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    services.dunst = {
      inherit (cfg) enable;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
        size = "32x32";
      };
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          width = 300;
          height = 300;
          origin = "top-right";
          offset = "20x20";
          scale = 0;
          notification_limit = 20;
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 0;
          progress_bar_min_width = 125;
          progress_bar_max_width = 250;
          progress_bar_corner_radius = 4;
          # icon_corner_radius = "\${hypy_border}";
          indicate_hidden = "yes";
          transparency = 10;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 10;
          frame_width = 5;
          gap_size = 5;
          sort = "yes";
          # idle_threshold = 0;
          line_height = 3;
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";
          # enable_recursive_icon_lookup = true;
          icon_position = "left";
          sticky_history = true;
          history_length = 20;
          dmenu = "${pkgs.rofi}/bin/rofi -p dmenu:";
          browser = "${pkgs.${browser}}/bin/${browser}";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          corner_radius = 10;
          ignore_dbusclose = false;
          force_xwayland = false;
          force_xinerama = false;
          mouse_left_click = "do_action, close_current";
          mouse_right_click = "close_current";
        };
        experimental = {
          per_monitor_dpi = false;
        };
        urgency_low = {
          timeout = 10;
        };
        urgency_normal = {
          timeout = 10;
        };
        urgency_critical = {
          timeout = 10;
        };
      };
    };
  };
}
