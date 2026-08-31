{ self, ... }: {
  flake.nixosModules.rcmWorkConfig =
    {
      config,
      pkgs,
      ...
    }:
    {
      hardware.facter.reportPath = ./facter.json;
      imports = [
        self.nixosModules.rcm
      ];
      environment.systemPackages = [
        pkgs.sonar-scanner-cli
      ];
      networking.hostName = "rcm-work";
      sops.secrets."sonar-project.properties" = {
        sopsFile = "${self.outPath}/.secrets/rcm.yaml";
        owner = config.ironman.user.name;
        group = config.ironman.user.name;
        path = "/data/rcm/sonar-project.properties";
      };
      topology = {
        id = "rcm-work";
        self = {
          deviceType = "nixos";
          guestType = "nixos-container";
          interfaces.eth0 = {
            addresses = [
              "192.168.20.102"
            ];
            network = "work";
            physicalConnections = [
              (config.lib.topology.mkConnection "pve-work" "vmbr0")
            ];
            virtual = true;
          };
          name = "RCM";
          parent = "pve-work";
          services = {
            nginx.hidden = true;
            rcm = {
              icon = "services.rcm";
              info = "https://rcm.desk.niceastman.com";
              name = "RCM (Work)";
            };
          };
        };
      };
    };
}
