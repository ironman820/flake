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
        file.".config/is_personal".text = ''false'';
        shellAliases = {
          "sonars" = "sonar-scanner -Dsonar.projectKey=RCM -Dsonar.sources=. -Dsonar.host.url=https://qc.desk.niceastman.com -Dsonar.token=sqp_030096586777baff531e375a3e27ec0ce6fc779e";
        };
      };
      suites = {
        server.enable = true;
        servers.rcm = enabled;
      };
      virtual.guest.enable = true;
    };

    system.stateVersion = "23.05";
  };

}
