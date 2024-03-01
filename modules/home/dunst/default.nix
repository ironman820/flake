{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.mine.home.user.settings.applications) terminal;
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.dunst;
in {
  options.mine.home.dunst = {
    enable = mkEnableOption "Enable the module";
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
          follow = "none";
          width = 300;
          height = 300;
          origin = "top-center";
          offset = "0x30";
          scale = 0;
          notification_limit = 20;
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          progress_bar_corner_radius = 10;
          icon_corner_radius = 0;
          indicate_hidden = true;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 0;
          frame_width = 3;
          gap_size = 0;
          sort = true;
          line_height = 1;
          markup = "full";
          format = "<b>%s</b>\n%b";
          alignment = "left";
          vertical_alignment = "top";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
          enable_recursive_icon_lookup = true;
          icon_position = "left";
          sticky_history = true;
          history_length = 20;
          dmenu = "${pkgs.rofi}/bin/rofi -p dmenu:";
          browser = "${pkgs.${terminal}}/bin/${terminal}";
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
          timeout = 6;
        };
        urgency_normal = {
          timeout = 6;
        };
        urgency_critical = {
          timeout = 6;
        };
      };
    };
  };
}
