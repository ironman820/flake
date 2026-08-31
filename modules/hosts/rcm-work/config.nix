{ self, ... }: {
  flake.nixosModules.rcmWorkConfig = { config, pkgs, ... }: {
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
    topology.self = {
      deviceType = "nixos";
      guestType = "nixos-container";
      interfaces.eth0 = {
        addresses = [
          "192.168.20.102"
        ];
        network = "work";
        virtual = true;
      };
      name = "RCM";
      parent = "pve-work";
    };
  };
}
