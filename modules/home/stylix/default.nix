{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) either float package path str;
  inherit (lib.strings) concatStringsSep;

  cfg = config.mine.home.stylix;
  base16 = stlx.base16Scheme;
  tsp = config.mine.home.user.settings.transparancy;
  stlx = config.mine.home.user.settings.stylix;
in {
  options.mine.home.stylix = {
    enable = mkEnableOption "Enable the module";
    applicationOpacity = mkOpt float tsp.applicationOpacity "Opacity of standard Applications";
    base16Scheme = {
      enable = mkBoolOpt base16.enable "Whether to override the auto-generated theme";
      package = mkOpt package base16.package "Base Color Scheme";
      file = mkOpt str base16.file "File in the base color package to use";
    };
    desktopOpacity = mkOpt float tsp.desktopOpacity "Opacity of desktop features (bar, etc.)";
    image = mkOpt (either path str) stlx.image "Wallpaper image";
    inactiveOpacity = mkOpt float tsp.inactiveOpacity "Inactive application opacity";
    polarity = mkOpt str "dark" "Dark or light theme";
    terminalFontSize = mkOpt float stlx.fonts.terminalSize "Size of fonts in the terminal";
    terminalOpacity = mkOpt float tsp.terminalOpacity "Opacity of terminal windows";
  };

  config = mkIf cfg.enable {
    stylix = {
      inherit (cfg) image polarity;
      base16Scheme = mkIf cfg.base16Scheme.enable (concatStringsSep "/" [
        "${cfg.base16Scheme.package}"
        cfg.base16Scheme.file
      ]);
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = {
        monospace = {
          name = stlx.fonts.terminalFont;
          package = pkgs.nerdfonts;
        };
        sansSerif = {
          name = "DejaVuSansM Nerd Font";
          package = pkgs.nerdfonts;
        };
        serif = {
          name = "FiraCode Nerd Font";
          package = pkgs.nerdfonts;
        };
        sizes.terminal = cfg.terminalFontSize;
      };
      opacity = {
        applications = cfg.applicationOpacity;
        desktop = cfg.desktopOpacity;
        popups = 0.9;
        terminal = cfg.terminalOpacity;
      };
    };
  };
}
