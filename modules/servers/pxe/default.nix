{ config, inputs, lib, modulesPath, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.pxe;
  sys = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ({ config, pkgs, lib, modulesPath, ... }: {
        imports = [
          (modulesPath + "/installer/netboot/netboot-minimal.nix")
        ];
        config = {
          system.stateVersion = config.system.nixos.release;
        };
      })
    ];
  };
  build = sys.config.system.build;
in
{
  options.ironman.servers.pxe = {
    enable = mkBoolOpt false "Enable or disable pxe support";
  };

  config = mkIf cfg.enable {
    ironman = {
      servers = {
        lighttpd = {
          enable = true;
          root = "/etc/tftp";
        };
        nfs = {
          enable = true;
          exports = ''
            /etc/tftp/ubuntu  192.168.0.0/16(ro,insecure,no_root_squash,no_subtree_check)
          '';
        };
        tftp = {
          enable = true;
        };
      };
    };
    environment = {
      etc = {
        "tftp/pxelinux.0".source = "${pkgs.syslinux}/share/syslinux/pxelinux.0";
        "tftp/ldlinux.c32".source = "${pkgs.syslinux}/share/syslinux/ldlinux.c32";
        "tftp/libutil.c32".source = "${pkgs.syslinux}/share/syslinux/libutil.c32";
        "tftp/menu.c32".source = "${pkgs.syslinux}/share/syslinux/menu.c32";
        "tftp/syslinux.efi".source = "${pkgs.syslinux}/share/syslinux/efi64/syslinux.efi";
        "tftp/ubuntu".source = "${pkgs.ubuntuserver}/iso";
        "tftp/nix/bzImage".source = "${build.kernel}/bzImage";
        "tftp/nix/initrd".source = "${build.netbootRamdisk}/initrd";
        "tftp/nix/init".source = "${build.toplevel}/init";
        "tftp/pxelinux.cfg/default".text = ''
          UI menu.c32
          TIMEOUT 300
          LABEL Nix Netboot
            MENU LABEL Nix
            KERNEL http://192.168.258.8/nix/bzImage
            append init=${build.toplevel}/init initrd=http://192.168.258.8/nix/initrd nohibernate loglevel=4
          LABEL Nix Netboot With Console
            MENU LABEL Nix with Console
            KERNEL http://192.168.258.8/nix/bzImage
            append init=${build.toplevel}/init initrd=http://192.168.258.8/nix/initrd nohibernate loglevel=4 console=tty0 console=ttyS0,115200n8
          LABEL Ubuntu NFS boot
            MENU LABEL Ubuntu
            kernel http://192.168.254.8/ubuntu/casper/vmlinuz
            append initrd=http://192.168.254.8/ubuntu/casper/initrd nfsroot=192.168.254.8:/etc/tftp/ubuntu ro netboot=nfs boot=casper ip=dhcp ---
          LABEL Ubuntu Console NFS boot
            MENU LABEL Ubuntu Console Mode
            kernel http://192.168.254.8/ubuntu/casper/vmlinuz
            append initrd=http://192.168.254.8/ubuntu/casper/initrd nfsroot=192.168.254.8:/etc/tftp/ubuntu ro netboot=nfs boot=casper ip=dhcp console=tty0 console=ttyS0,115200n8
        '';
      };
    };
  };
}
