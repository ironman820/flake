{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.suites.workstation;
in {
  options.ironman.suites.workstation = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman = {
      boot.grub = enabled;
      chezmoi = enabled;
      gnome = enabled;
      gui-apps = enabled;
      sops = enabled;
      sync = enabled;
      virtual.host = enabled;
      yubikey = enabled;
    };
    environment.systemPackages = with pkgs; [
      ntfs3g
    ];
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
