{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.dm.sddm;
  imp = config.mine.impermanence.enable;
in {
  options.mine.dm.sddm = {
    enable = mkEnableOption "Enable SDDM";
    wayland = mkEnableOption "Enable Wayland support";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [pkgs.sddm-catppuccin];
      persistence."/persist/root".files = mkIf imp [
        "/var/lib/sddm/state.conf"
      ];
    };
    services.xserver = {
      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        theme = "catppuccin-mocha";
        wayland.enable = cfg.wayland;
      };
      enable = true;
    };
  };
}
