{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.mine.user.settings) applicationOpacity desktopOpacity;
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) either path str;

  cfg = config.mine.stylix;
  wallpaper = pkgs.runCommand "image.png" {} ''
    COLOR=$(${pkgs.yq}/bin/yq -r .base00 ${cfg.base16Scheme})
    COLOR="#"$COLOR
    ${pkgs.imagemagick}/bin/magick ${cfg.image} xc:$COLOR -fx '1-(1-v.p{0,0})*(1-u)' $out
  '';
in {
  options.mine.stylix = {
    enable = mkBoolOpt true "Enable the module";
    autoImport = mkBoolOpt false "Automatically import the home manager module";
    base16Scheme = mkOpt (either path str) "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml" "Base Color Scheme";
    followSystem = mkBoolOpt true "Home manager follows the system config";
    image = mkOpt (either path str) ../../../systems/x86_64-linux/e105-laptop/voidbringer.png "Wallpaper image";
    polarity = mkOpt str "dark" "Dark or light polorized themes";
  };
  config = mkIf cfg.enable {
    stylix = {
      inherit (cfg) base16Scheme polarity;
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
        applications = applicationOpacity;
        desktop = desktopOpacity;
        popups = 0.9;
        terminal = 0.6;
      };
    };
  };
}
