{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.virtual.host;
in {
  options.ironman.virtual.host = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman = {
      home.extraOptions.home.packages = with pkgs; [
        virt-manager
      ];
      user.extraGroups = [
        "libvirtd"
      ];
    };
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.package = pkgs.qemu_kvm;
      };
    };
  };
}
