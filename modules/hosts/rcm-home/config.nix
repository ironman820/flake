{
  self,
  ...
}:
{
  flake.nixosModules.rcmHomeConfig =
    { config, pkgs, ... }:
    let
      userName = config.ironman.user.name;
    in
    {
      environment.systemPackages = with pkgs; [
        sonar-scanner-cli
      ];
      hardware.facter.reportPath = ./facter.json;
      ironman = {
        rcm.enable = true;
        server.unattended = false;
      };
      networking = {
        hostName = "rcm";
        nameservers = [
          "192.168.248.2"
        ];
      };
      sops.secrets."sonar-project.properties" = {
        sopsFile = "${self.outPath}/.secrets/rcm.yaml";
        owner = userName;
        group = userName;
        path = "/data/rcm/sonar-project.properties";
      };
    };
}
