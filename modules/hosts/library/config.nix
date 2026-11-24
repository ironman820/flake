{ self, ... }: {
  flake.nixosModules.libraryConfig = { config, ... }: {
    hardware.facter.reportPath = ./facter.json;
    ironman.bookorbit = {
      enable = true;
      environmentFile = config.sops.secrets.bookorbit_env.path;
    };
    networking = {
      hostName = "library";
      nameservers = [
        "192.168.248.2"
      ];
    };
    sops.secrets.bookorbit_env =
      let
        inherit (config.ironman.user) name;
      in
      {
        sopsFile = "${self.outPath}/.secrets/library.yaml";
        owner = name;
        group = name;
      };
  };
}
