{config, lib, pkgs, ...}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.gui-apps.chromium;
  plasma = config.mine.de.plasma;
in {
  options.mine.gui-apps.chromium = {
    enable = mkEnableOption "chromium";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      google-chrome
    ];
    programs.chromium = {
      enable = true;
      enablePlasmaBrowserIntegration = mkIf plasma.enable true;
    };
  };
}
