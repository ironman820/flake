{ self, ... }: {
  flake.nixosModules.libraryConfig = {
    hardware.facter.reportPath = ./facter.json;
    ironman.bookkeep.enable = true;
    networking = {
      hostName = "library";
      nameservers = [
        "192.168.248.2"
      ];
    };
    services = {
      postgresql = {
        enable = true;
        ensureDatabases = [
          "bookkeep"
        ];
        ensureUsers = [
          {
            ensureDBOwnership = true;
            name = "bookkeep";
          }
        ];
      };
      redis.servers.bookkeep.enable = true;
    };
    sops.secrets.bookkeep_env = {
      sopsFile = "${self.outPath}/.secrets/library.yaml";
    };
  };
}
