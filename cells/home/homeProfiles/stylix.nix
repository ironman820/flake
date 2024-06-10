{
  cell,
  config,
  inputs,
  osConfig,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  b = oc.base16Scheme;
  c = config.vars;
  l = nixpkgs.lib // mine.lib // builtins;
  oc = osConfig.vars.stylix;
  s = c.stylix;
  sb = s.base16Scheme;
  sf = s.fonts;
  t = l.types;
  tr = c.transparency;
in {
  options.vars.stylix = {
    fonts = {
      terminalFont = l.mkOpt t.str sf.terminalFont "Default font for the terminal";
      terminalSize = l.mkOpt t.float sf.terminalSize "Size of terminal font";
      waybarSize = l.mkOpt t.int sf.waybarSize "Size of font on waybar";
    };
    image = l.mkOpt (t.either t.path t.str) oc.image "Wallpaper image";
    base16Scheme = {
      enable = l.mkBoolOpt b.enable "Whether to override the auto-generated theme";
      package = l.mkOpt t.package b.package "Base Color Scheme";
      file = l.mkOpt t.str b.file "File in the base color package to use";
    };
    desktopOpacity = l.mkOpt t.float tr.desktopOpacity "Opacity of desktop features (bar, etc.)";
    inactiveOpacity = l.mkOpt t.float tr.inactiveOpacity "Inactive application opacity";
    polarity = l.mkOpt t.str "dark" "Dark or light theme";
    terminalFontSize = l.mkOpt t.float sf.terminalSize "Size of fonts in the terminal";
    terminalOpacity = l.mkOpt t.float tr.terminalOpacity "Opacity of terminal windows";
  };

  config = {
    stylix = {
      inherit (s) image polarity;
      base16Scheme = l.mkIf sb.enable (l.concatStringsSep "/" [
        "${sb.package}"
        sb.file
      ]);
      cursor = {
        package = nixpkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = {
        monospace = {
          name = sf.terminalFont;
          package = nixpkgs.nerdfonts;
        };
        sansSerif = {
          name = "DejaVuSansM Nerd Font";
          package = nixpkgs.nerdfonts;
        };
        serif = {
          name = "FiraCode Nerd Font";
          package = nixpkgs.nerdfonts;
        };
        sizes.terminal = sf.terminalSize;
      };
      opacity = {
        applications = tr.applicationOpacity;
        desktop = tr.desktopOpacity;
        popups = 0.9;
        terminal = tr.terminalOpacity;
      };
    };
  };
}
