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
  };
}
