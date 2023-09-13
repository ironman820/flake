{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    ironman = {
      home.extraOptions.home.file.".config/is_personal".text = ''true'';
      servers.pxe = {
        enable = true;
        netboot = true;
        nix = false;
      };
      suites.server.enable = true;
      virtual.guest.enable = true;
    };

    system.stateVersion = "23.05";
  };
}
