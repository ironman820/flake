{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) attrs either float path str;
  inherit (lib.strings) concatStrings;

  cfg = config.mine.stylix;
  cbs = cfg.base16Scheme;
  stlx = usr.stylix;
  tsp = usr.transparancy;
  usr = config.mine.user.settings;
  wallpaper = pkgs.runCommand "image.png" {} ''
    COLOR=$(${pkgs.yq}/bin/yq -r .base00 ${pkgs.${cbs.package}}${cbs.file})
    COLOR="#"$COLOR
    ${pkgs.imagemagick}/bin/magick ${cfg.image} xc:$COLOR -fx '1-(1-v.p{0,0})*(1-u)' $out
  '';
in {
  options.mine.stylix = {
    enable = mkBoolOpt true "Enable the module";
    applicationOpacity = mkOpt float tsp.applicationOpacity "Opacity of standard Applications";
    autoImport = mkEnableOption "Automatically import the home manager module";
    base16Scheme = mkOpt attrs stlx.base16Scheme "Base Color Scheme";
    desktopOpacity = mkOpt float tsp.desktopOpacity "Opacity of desktop features (bar, etc.)";
    followSystem = mkBoolOpt true "Home manager follows the system config";
    image = mkOpt (either path str) stlx.image "Wallpaper image";
    polarity = mkOpt str "dark" "Dark or light polorized themes";
    terminalOpacity = mkOpt float tsp.terminalOpacity "Opacity of terminal windows";
  };
  config = mkIf cfg.enable {
    stylix = {
      inherit (cfg) polarity;
      base16Scheme = concatStrings [
        "${pkgs.${cbs.package}}"
        cbs.file
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
      homeManagerIntegration = {
        inherit (cfg) autoImport followSystem;
      };
      image = wallpaper;
      opacity = {
        applications = cfg.applicationOpacity;
        desktop = cfg.desktopOpacity;
        popups = 0.9;
        terminal = cfg.terminalOpacity;
      };
    };
  };
}
