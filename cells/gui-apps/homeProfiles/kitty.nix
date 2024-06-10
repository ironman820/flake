{
  cell,
  config,
  inputs,
}: let
  inherit (config.vars) stylix;
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars.kitty;
  l = nixpkgs.lib // mine.lib // builtins;
  sf = stylix.fonts;
  t = l.types;
in {
  options.vars.kitty = {
    extraConfig = l.mkOpt t.lines "" "Extra configuration options";
    font_family = l.mkOpt t.str sf.terminalFont "Default settings for ";
    font_size = l.mkOpt t.float sf.terminalSize "Default size for terminal font";
    keybindings = l.mkOpt t.attrs {} "Attr definitions for key bindings";
    settings = {
      bold_font = l.mkOpt t.str "auto" "Font boldness";
      bold_italic_font = l.mkOpt t.str "auto" "bold italic font";
      cursor_shape = l.mkOpt t.str "beam" "Cursor shape";
      enable_audio_bell = l.mkEnableOption false;
      italic_font = l.mkOpt t.str "auto" "Default settings for ";
      kitty_mod = l.mkOpt t.str "ctrl+shift" "Default settings for ";
      mouse_hide_wait = l.mkOpt t.int 0 "How long to wait befor hiding the mouse";
      scrollback_lines = l.mkOpt t.int 10000 "How many lines the scrollback pager holds";
      scrollback_pager = l.mkOpt t.str "bat" "Default settings for ";
      tab_bar_style = l.mkOpt t.str "powerline" "Default settings for ";
      update_check_interval = l.mkOpt t.int 0 "How often to check for updates";
    };
  };

  config = {
    vars.kitty = {
      keybindings = {
        # "alt+left" = "send_text all x1bx62";
        # "alt+right" = "send_text all x1bx66";
        "kitty_mod+equal" = "change_font_size all +2.0";
        "kitty_mod+minus" = "change_font_size all -2.0";
        "kitty_mod+backspace" = "change_font_size all 0";
      };
    };
    home = {
      # file.".config/kitty/themes.conf".source = nixpkgs.catppuccin-kitty;
      packages = [
        nixpkgs.nerdfonts
      ];
    };
    programs.kitty = {
      inherit (c) extraConfig settings keybindings;
      enable = true;
      font = {
        name = l.mkForce c.font_family;
        size = l.mkForce c.font_size;
      };
    };
  };
}
