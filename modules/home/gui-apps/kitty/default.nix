{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (config.mine.home.user.settings) stylix;
  inherit (stylix.fonts) terminalFont terminalSize;
  inherit (lib) mkEnableOption mkForce mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) attrs float int lines str;

  cfg = config.mine.home.gui-apps.kitty;
  os = osConfig.mine.gui-apps.kitty;
in {
  options.mine.home.gui-apps.kitty = {
    enable = mkBoolOpt os.enable "Setup kitty";
    extraConfig = mkOpt lines "" "Extra configuration options";
    font_family = mkOpt str terminalFont "Default settings for ";
    font_size = mkOpt float terminalSize "Default size for terminal font";
    keyBindings = mkOpt attrs {} "Attr definitions for key bindings";
    settings = {
      bold_font = mkOpt str "auto" "Font boldness";
      bold_italic_font = mkOpt str "auto" "bold italic font";
      cursor_shape = mkOpt str "beam" "Cursor shape";
      enable_audio_bell = mkEnableOption false;
      italic_font = mkOpt str "auto" "Default settings for ";
      kitty_mod = mkOpt str "ctrl+shift" "Default settings for ";
      mouse_hide_wait = mkOpt int 0 "How long to wait befor hiding the mouse";
      scrollback_lines = mkOpt int 10000 "How many lines the scrollback pager holds";
      scrollback_pager = mkOpt str "bat" "Default settings for ";
      tab_bar_style = mkOpt str "powerline" "Default settings for ";
      update_check_interval = mkOpt int 0 "How often to check for updates";
    };
  };

  config = mkIf cfg.enable {
    mine.home.gui-apps.kitty = {
      extraConfig = ''
        include themes/mocha.conf
      '';
      keyBindings = {
        "alt+left" = "send_text all x1bx62";
        "alt+right" = "send_text all x1bx66";
        "kitty_mod+equal" = "change_font_size all +2.0";
        "kitty_mod+minus" = "change_font_size all -2.0";
        "kitty_mod+backspace" = "change_font_size all 0";
      };
    };
    home = {
      file.".config/kitty/themes.conf".source = pkgs.catppuccin-kitty;
      packages = [
        pkgs.nerdfonts
      ];
    };
    programs.kitty = {
      inherit (cfg) extraConfig settings;
      enable = true;
      font = {
        name = mkForce cfg.font_family;
        size = mkForce cfg.font_size;
      };
    };
  };
}
