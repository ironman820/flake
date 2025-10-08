{
  config,
  lib,
  myPkgs,
  ...
}:
let
  inherit (config.mine.home.user.settings) stylix;
  inherit (stylix.fonts) terminalFont terminalSize;
  inherit (lib) mkEnableOption mkForce mkIf;
  inherit (lib.mine) enabled mkBoolOpt mkOpt;
  inherit (lib.types)
    attrs
    float
    int
    lines
    str
    ;

  cfg = config.mine.home.kitty;
in
{
  options.mine.home.kitty = {
    enable = mkEnableOption "Install and setup kitty";
    extraConfig = mkOpt lines "" "Extra configuration options";
    font_family = mkOpt str terminalFont "Default settings for ";
    font_size = mkOpt float terminalSize "Default size for terminal font";
    keyBindings = mkOpt attrs { } "Attr definitions for key bindings";
  };

  config = mkIf cfg.enable {
    mine.home.kitty = {
      keyBindings = {
        "alt+left" = "send_text all x1bx62";
        "alt+right" = "send_text all x1bx66";
        "kitty_mod+equal" = "change_font_size all +2.0";
        "kitty_mod+minus" = "change_font_size all -2.0";
        "kitty_mod+backspace" = "change_font_size all 0";
      };
    };
    home = {
      file.".config/kitty/themes.conf".source = myPkgs.catppuccin-kitty;
    };
    programs.kitty = enabled // {
      inherit (cfg) extraConfig;
      keybindings = cfg.keyBindings;
      font = {
        name = mkForce cfg.font_family;
        size = mkForce cfg.font_size;
      };
      settings = {
        bold_font = "auto";
        bold_italic_font = "auto";
        cursor_shape = "beam";
        enable_audio_bell = false;
        italic_font = "auto";
        kitty_mod = "ctrl+shift";
        mouse_hide_wait = 0;
        scrollback_lines = 10000;
        scrollback_pager = "bat";
        tab_bar_style = "powerline";
        update_check_interval = 0;
      };
    };
  };
}
