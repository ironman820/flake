{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.suites.virtual-workstation;
in {
  options.mine.suites.virtual-workstation = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine = {
      hyprland = enabled;
      # sync = enabled;
      sops = enabled;
      virtual.guest = enabled;
    };
    powerManagement.cpuFreqGovernor = "performance";
    security.sudo.wheelNeedsPassword = false;
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
