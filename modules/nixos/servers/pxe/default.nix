{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (lib.mine) mkBoolOpt mkOpt mkPxeMenu;
  inherit (lib.types) attrs;
  inherit (sys.config.system) build;

  cfg = config.mine.servers.pxe;
  nwk = config.mine.networking.basic;
  sys = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ({
        config,
        pkgs,
        lib,
        modulesPath,
        ...
      }: {
        imports = [
          (modulesPath + "/installer/netboot/netboot-minimal.nix")
        ];
        config = {
          system.stateVersion = config.system.nixos.release;
        };
      })
    ];
  };
  netbootxyzpxe = pkgs.fetchurl {
    url = "https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe";
    sha256 = "sha256-RZhq+sdc5KgRjkc3Vapz8ov2pKXX9Zd7I8cEy/0hlp0=";
  };
in {
  options.mine.servers.pxe = {
    enable = mkBoolOpt false "Enable or disable pxe support";
    nix = mkBoolOpt true "Set up Nix Netboot";
    ubuntu = mkBoolOpt false "Set up Ubuntu Netboot";
    netboot = mkBoolOpt false "Set up Netboot.xyz";
    menu = mkOpt attrs {} "Menu options (will be concatenated together)";
  };

  config = mkIf cfg.enable {
    mine = {
      servers = {
        lighttpd = {
          enable = true;
          root = "/etc/tftp";
        };
        nfs = mkIf (cfg.ubuntu && (!cfg.netboot)) {
          enable = true;
          exports = ''
            /etc/tftp/ubuntu  192.168.0.0/16(ro,insecure,no_root_squash,no_subtree_check)
          '';
        };
        pxe.menu = mkIf (!cfg.netboot) {
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
      etc = mkMerge [
        (mkIf (!cfg.netboot) {
          "tftp/pxelinux.0".source = "${pkgs.syslinux}/share/syslinux/pxelinux.0";
          "tftp/ldlinux.c32".source = "${pkgs.syslinux}/share/syslinux/ldlinux.c32";
          "tftp/ldlinux.e64".source = "${pkgs.syslinux}/share/syslinux/efi64/ldlinux.e64";
          "tftp/libutil.c32".source = "${pkgs.syslinux}/share/syslinux/efi64/libutil.c32";
          "tftp/menu.c32".source = "${pkgs.syslinux}/share/syslinux/efi64/menu.c32";
          "tftp/syslinux.efi".source = "${pkgs.syslinux}/share/syslinux/efi64/syslinux.efi";
          "tftp/pxelinux.cfg/default".text = mkPxeMenu cfg.menu;
          "tftp/nix/bzImage" = mkIf cfg.nix {source = "${build.kernel}/bzImage";};
          "tftp/nix/initrd" = mkIf cfg.nix {source = "${build.netbootRamdisk}/initrd";};
          "tftp/nix/init" = mkIf cfg.nix {source = "${build.toplevel}/init";};
          "tftp/ubuntu" = mkIf cfg.ubuntu {source = "${pkgs.ubuntuserver}/iso";};
        })
        (mkIf cfg.netboot {
          "tftp/syslinux.efi".source = "${pkgs.netbootxyz-efi}";
          "tftp/netboot.xyz.kpxe".source = netbootxyzpxe;
        })
      ];
    };
  };
}
