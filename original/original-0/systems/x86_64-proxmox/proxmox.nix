{
  lib,
  modulesPath,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    (modulesPath + "/virtualisation/proxmox-image.nix")
  ];
  config = {
    proxmox.qemuConf = {
      boot = "order=scsi0;net0";
      cores = mkDefault 2;
      memory = mkDefault 2048;
      bios = "ovmf";
      bootSize = mkDefault "512M";
      # filenameSuffix = mkDefault "9999-nixos_template";
    };
  };
}
