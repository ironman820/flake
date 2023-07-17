{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.pxe;
in {
  options.ironman.servers.pxe = {
    enable = mkBoolOpt false "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    ironman = {
      home.file = {
        "tftp/ldlinux.e64".source = "${pkgs.syslinux}/share/syslinux/efi64/ldlinux.e64";
        "tftp/libutil.c32".source = "${pkgs.syslinux}/share/syslinux/efi64/libutil.c32";
        "tftp/menu.c32".source = "${pkgs.syslinux}/share/syslinux/efi64/menu.c32";
        "tftp/syslinux.efi".source = "${pkgs.syslinux}/share/syslinux/efi64/syslinux.efi";
        "tftp/nix" = {
          source = "${pkgs.nixiso}/iso";
          recursive = true;
        };
      };
      servers = {
        tftp = enabled;
      };
    };
    environment.systemPackages = with pkgs; [
      syslinux
    ];

  };
}
