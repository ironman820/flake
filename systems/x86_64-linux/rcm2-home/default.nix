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
      home.extraOptions.home = {
        shellAliases = {
          "sonars" = "sonar-scanner   -Dsonar.projectKey=RCM2   -Dsonar.sources=.   -Dsonar.host.url=https://qc.desk.niceastman.com   -Dsonar.token=sqp_4de32f09e2137f5459d22b658bf98cccfc98e533";
        };
      };
      suites.server = {
        enable = true;
        rcm2.enable = false;
      };
      virtual.guest.enable = true;
    };

    system.stateVersion = "23.05";
  };

}
