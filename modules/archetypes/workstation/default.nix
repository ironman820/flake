{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.archetypes.workstation;
in {
  options.archetypes.workstation = with types; {
    enable = mkBoolOpt true "Whether or not to set the machine up as a workstation.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ntfs3g ];
    ironman = {
      boot.plymouth = enabled;
      suites.desktop = enabled;
    };
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 90;
    };
  };
}