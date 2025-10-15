{
  flake.homeModules.kitty =
    {
      pkgs,
      ...
    }:
    {
      home.file.".config/kitty/themes.conf".source = pkgs.local.catppuccin-kitty;
      programs.kitty = {
        enable = true;
        font = {
          name = "Inconsolata Nerd Font Mono";
          size = 12.0;
        };
        keybindings = {
          "alt+left" = "send_text all x1bx62";
          "alt+right" = "send_text all x1bx66";
          "kitty_mod+equal" = "change_font_size all +2.0";
          "kitty_mod+minus" = "change_font_size all -2.0";
          "kitty_mod+backspace" = "change_font_size all 0";
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
