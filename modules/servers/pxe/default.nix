{ config, inputs, lib, modulesPath, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.pxe;
  nwk = config.ironman.networking;
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
  options.ironman.servers.pxe = with types; {
    enable = mkBoolOpt false "Enable or disable pxe support";
    nix = mkBoolOpt true "Set up Nix Netboot";
    ubuntu = mkBoolOpt false "Set up Ubuntu Netboot";
    menu = mkOpt attrs { } "Menu options (will be concatenated together)";
  };

  config = mkIf cfg.enable {
    ironman = {
      servers = {
        lighttpd = {
          enable = true;
          root = "/etc/tftp";
        };
        nfs = mkIf cfg.ubuntu {
          enable = true;
          exports = ''
            /etc/tftp/ubuntu  192.168.0.0/16(ro,insecure,no_root_squash,no_subtree_check)
          '';
        };
        pxe.menu = {
          nix = mkIf cfg.nix {
            label = "Nix";
            kernel = "http://${nwk.address}/nix/bzImage";
            append = "init=${build.toplevel}/init initrd=http://${nwk.address}/nix/initrd nohibernate loglevel=4";
          };
          nixConsole = mkIf cfg.nix {
            label = "Nix with Console";
            kernel = "http://${nwk.address}/nix/bzImage";
            append = "init=${build.toplevel}/init initrd=http://${nwk.address}/nix/initrd nohibernate loglevel=4 console=tty0 console=ttyS0,115200n8";
          };
          ubuntu = mkIf cfg.ubuntu {
            label = "Ubuntu";
            kernel = "http://${nwk.address}/ubuntu/casper/vmlinuz";
            append = "initrd=http://${nwk.address}/ubuntu/casper/initrd nfsroot=${nwk.address}:/etc/tftp/ubuntu ro netboot=nfs boot=casper ip=dhcp ---";
          };
          ubuntuConsole = mkIf cfg.ubuntu {
            label = "Ubuntu Console Mode";
            kernel = "http://${nwk.address}/ubuntu/casper/vmlinuz";
            append = "initrd=http://${nwk.address}/ubuntu/casper/initrd nfsroot=${nwk.address}:/etc/tftp/ubuntu ro netboot=nfs boot=casper ip=dhcp console=tty0 console=ttyS0,115200n8";
          };
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
        "tftp/ldlinux.e64".source = "${pkgs.syslinux}/share/syslinux/efi64/ldlinux.e64";
        "tftp/libutil.c32".source = "${pkgs.syslinux}/share/syslinux/efi64/libutil.c32";
        "tftp/menu.c32".source = "${pkgs.syslinux}/share/syslinux/efi64/menu.c32";
        "tftp/syslinux.efi".source = "${pkgs.syslinux}/share/syslinux/efi64/syslinux.efi";
        "tftp/pxelinux.cfg/default".text = mkPxeMenu cfg.menu;
        "tftp/nix/bzImage" = mkIf cfg.nix { source = "${build.kernel}/bzImage"; };
        "tftp/nix/initrd" = mkIf cfg.nix { source = "${build.netbootRamdisk}/initrd"; };
        "tftp/nix/init" = mkIf cfg.nix { source = "${build.toplevel}/init"; };
        "tftp/ubuntu" = mkIf cfg.ubuntu { source = "${pkgs.ubuntuserver}/iso"; };
      };
    };
  };
}
