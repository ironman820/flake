{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine.user.settings.applications) browser;

  cfg = config.mine.de.hyprland.dunst;
in {
  options.mine.de.hyprland.dunst = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        dunst
        papirus-icon-theme
        rofi
      ]
      ++ [
        pkgs.${browser}
      ];
  };
}
