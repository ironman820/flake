{ config, lib, pkgs, ... }:
let
  inherit (lib) mkDefault mkForce mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) attrs lines;
  inherit (pkgs) nerdfonts;

  cfg = config.ironman.home.kitty;
in {
  options.ironman.home.kitty = {
    enable = mkBoolOpt true "Setup kitty";
    extraConfig = mkOpt lines "" "Extra configuration options";
    keyBindings = mkOpt attrs {
      "alt+left" = mkDefault "send_text all x1bx62";
      "alt+right" = mkDefault "send_text all x1bx66";
      # "ctrl+d" = mkDefault "new_window";
      "kitty_mod+equal" = mkDefault "change_font_size all +2.0";
      "kitty_mod+minus" = mkDefault "change_font_size all -2.0";
      "kitty_mod+backspace" = mkDefault "change_font_size all 0";
    };
    settings = mkOpt attrs {
      background_opacity = mkForce "0.9";
      bold_font = mkDefault "auto";
      bold_italic_font = mkDefault "auto";
      cursor_shape = mkDefault "beam";
      enable_audio_bell = mkDefault false;
      font_family = mkDefault "FiraCode Nerd Font Mono";
      font_size = mkDefault 12;
      italic_font = mkDefault "auto";
      kitty_mod = mkDefault "ctrl+shift";
      mouse_hide_wait = mkDefault 0;
      scrollback_lines = mkDefault 10000;
      scrollback_pager = mkDefault "bat";
      tab_bar_style = mkDefault "powerline";
      update_check_interval = mkDefault 0;
    } "Settings from the kitty config file";
  };

  config = mkIf cfg.enable {
    ironman.home.kitty.extraConfig = ''
      include themes/mocha.conf
    '';
    home = {
      file.".config/kitty/themes.conf".source = pkgs.catppuccin-kitty;
      packages = [ nerdfonts ];
    };
    programs.kitty = {
      inherit (cfg) extraConfig settings;
      enable = true;
    };
  };
}
