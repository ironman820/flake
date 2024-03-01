{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) attrs either float path str;
  inherit (lib.strings) concatStrings;

  cfg = config.mine.home.stylix;
  tsp = config.mine.home.user.settings.transparancy;
  stlx = config.mine.home.user.settings.stylix;
in {
  options.mine.home.stylix = {
    enable = mkEnableOption "Enable the module";
    applicationOpacity = mkOpt float tsp.applicationOpacity "Opacity of standard Applications";
    base16Scheme = mkOpt attrs stlx.base16Scheme "Base color scheme";
    desktopOpacity = mkOpt float tsp.desktopOpacity "Opacity of desktop features (bar, etc.)";
    image = mkOpt (either path str) stlx.image "Wallpaper image";
    inactiveOpacity = mkOpt float tsp.inactiveOpacity "Inactive application opacity";
    polarity = mkOpt str "dark" "Dark or light theme";
    terminalOpacity = mkOpt float tsp.terminalOpacity "Opacity of terminal windows";
  };

  config = mkIf cfg.enable {
    stylix = {
      inherit (cfg) image polarity;
      base16Scheme = concatStrings [
        "${pkgs.${cfg.base16Scheme.package}}"
        cfg.base16Scheme.file
      ];
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = {
        monospace = {
          name = "FiraCode Nerd Font Mono";
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
