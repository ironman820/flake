{ config, inputs, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = with lib; {
    environment.systemPackages = with pkgs; [
      openssl
    ];
    ironman = {
      home.extraOptions.home.file.".config/is_personal".text = ''false'';
      suites = {
        server.enable = true;
        servers.rcm = enabled;
      };
      virtual.guest.enable = true;
    };

    system.stateVersion = "23.05";
  };

}
