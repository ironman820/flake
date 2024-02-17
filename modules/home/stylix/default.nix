{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  inherit (config.mine.home.user.settings) applicationOpacity desktopOpacity;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) disabled mkOpt;
  inherit (lib.types) either path str;

  cfg = config.mine.home.stylix;
in {
  options.mine.home.stylix = {
    enable = mkEnableOption "Enable the module";
    base16Scheme = mkOpt (either path str) osConfig.stylix.base16Scheme "Base color scheme";
    image = mkOpt (either path str) osConfig.stylix.image "Wallpaper image";
    polarity = mkOpt str "dark" "Dark or light theme";
  };

  config = mkIf cfg.enable {
    stylix = {
      inherit (cfg) base16Scheme image polarity;
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
        applications = applicationOpacity;
        desktop = desktopOpacity;
        popups = 0.9;
        terminal = 0.6;
      };
      targets.bat = disabled;
    };
  };
}
