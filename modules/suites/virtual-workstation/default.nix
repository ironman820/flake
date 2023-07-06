{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.suites.virtual-workstation;
in {
  options.ironman.suites.virtual-workstation = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman = {
      chezmoi = enabled;
      gnome = enabled;
      sync = enabled;
      sops = enabled;
      virtual.guest = enabled;
    };
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
