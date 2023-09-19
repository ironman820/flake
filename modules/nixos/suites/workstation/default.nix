{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.suites.workstation;
in
{
  options.ironman.suites.workstation = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman = {
      boot.grub = enabled;
      gnome = enabled;
      java = enabled;
      sops = enabled;
      sync = enabled;
      virtual.host = enabled;
      yubikey = enabled;
    };
    environment.systemPackages = with pkgs; [
      hplip
      ntfs3g
    ];
  };
}
