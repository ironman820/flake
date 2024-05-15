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

  cfg = config.mine.stylix;
  base16 = stlx.base16Scheme;
  cbs = cfg.base16Scheme;
  stlx = usr.stylix;
  tsp = usr.transparancy;
  usr = config.mine.user.settings;
in {
  options.mine.stylix = {
    enable = mkBoolOpt true "Enable the module";
    applicationOpacity = mkOpt float tsp.applicationOpacity "Opacity of standard Applications";
    autoImport = mkEnableOption "Automatically import the home manager module";
    base16Scheme = {
      enable = mkBoolOpt base16.enable "Whether to override the auto-generated theme";
      package = mkOpt package base16.package "Base Color Scheme";
      file = mkOpt str base16.file "File in the base color package to use";
    };
    desktopOpacity = mkOpt float tsp.desktopOpacity "Opacity of desktop features (bar, etc.)";
    followSystem = mkBoolOpt true "Home manager follows the system config";
    image = mkOpt (either path str) stlx.image "Wallpaper image";
    polarity = mkOpt str "dark" "Dark or light polorized themes";
    terminalOpacity = mkOpt float tsp.terminalOpacity "Opacity of terminal windows";
  };
  config = mkIf cfg.enable {
    stylix = {
      inherit (cfg) image polarity;
      base16Scheme = mkIf cfg.base16Scheme.enable (concatStringsSep "/" [
        "${cbs.package}"
        cbs.file
      ]);
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
      homeManagerIntegration = {
        inherit (cfg) autoImport followSystem;
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
