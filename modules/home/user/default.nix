{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt vars;
  inherit (lib.types) either float nullOr path str;
  cfg = config.mine.home.user;
  home-directory =
    if cfg.name == null
    then null
    else "/home/${cfg.name}";
in {
  options.mine.home.user = {
    enable = mkBoolOpt true "Enable user's home manager";
    email = mkOpt str "29488820+ironman820@users.noreply.github.com" "User email";
    fullName = mkOpt str "Nicholas Eastman" "Full Name";
    homeDirectory = mkOpt (nullOr str) home-directory "The user's home directory";
    name = mkOpt (nullOr str) config.snowfallorg.user.name "User Name";
    settings = {
      applications = let
        apps = vars.applications;
      in {
        browser = mkOpt str apps.browser "Default browser";
        fileManager = mkOpt str apps.fileManager "Default fileManager";
        terminal = mkOpt str apps.terminal "Default Terminal";
      };
      stylix = let
        stlx = vars.stylix;
      in {
        base16Scheme = {
          package = mkOpt str stlx.base16Scheme.package "Package name for color scheme";
          file = mkOpt str stlx.base16Scheme.file "file path to color scheme in package";
        };
        image = mkOpt (either path str) stlx.image "Default wallpaper image";
      };
      transparancy = let
        tsp = vars.transparancy;
      in {
        applicationOpacity = mkOpt float tsp.applicationOpacity "Default opacity for normal applications";
        desktopOpacity = mkOpt float tsp.desktopOpacity "Opacity for desktop objects like bars";
        inactiveOpacity = mkOpt float tsp.inactiveOpacity "Opacity for inactive applications";
        terminalOpacity = mkOpt float tsp.terminalOpacity "Opacity for terminal windows";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      inherit (cfg) homeDirectory;
      username = cfg.name;
    };
  };
}
