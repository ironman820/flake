{lib, ...}: let
  inherit (builtins) toString;
  inherit (lib) mkForce;
  inherit (lib.mine) enabled;
in {
  imports = [
    ./networking.nix
    ../proxmox.nix
  ];

  config = {
    mine = {
      servers.pxe = {
        enable = true;
        netboot = true;
        nix = false;
      };
      suites.server = enabled;
      virtual.guest = enabled;
    };
    proxmox.qemuConf = {
      virtio0 = "storage:vm-9999-disk-0";
      name = "nixos-pxe";
      diskSize = mkForce (toString (64 * 1024));
      # filenameSuffix = "9999-nixos-pxe";
    };

    system.stateVersion = "23.05";
  };
}
