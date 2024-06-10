{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  inherit (mine.packages) base16-onedark-scheme;
  c = config.vars;
  l = nixpkgs.lib // mine.lib // builtins;
  s = c.stylix;
  sb = s.base16Scheme;
  sf = s.fonts;
  t = l.types;
  tr = c.transparency;
in {
  options.vars.stylix = {
    base16Scheme = {
      enable = l.mkBoolOpt true "Enable base 16 scheme override";
      package = l.mkOpt (l.either l.package l.str) base16-onedark-scheme "Package to get theme from";
      file = l.mkOpt l.str "theme.yaml" "File in the theme package to use";
    };
    fonts = {
      terminalFont = l.mkOpt t.str "IosevkaTerm Nerd Font" "Default font for the terminal";
      terminalSize = l.mkOpt t.float 12.0 "Size of terminal font";
      waybarSize = l.mkOpt t.int 16 "Size of font on waybar";
    };
    image = l.mkOpt (t.either t.path t.str) ./__files/no-place-like-homeV6.jpg "Wallpaper image";
  };
  config = {
    stylix = {
      inherit (s) image;
      base16Scheme = l.mkIf sb.enable (l.concatStringsSep "/" [
        sb.package
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
      homeManagerIntegration = {
        autoImport = false;
        followSystem = true;
      };
      opacity = {
        applications = tr.applicationOpacity;
        desktop = tr.dekstopOpacity;
        popups = 0.9;
        terminal = tr.terminalOpacity;
      };
      polarity = "dark";
    };
  };
}
