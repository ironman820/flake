{ self, ... }: {
  flake.nixosModules.storageConfig = { config, ... }: {
    hardware.facter.reportPath = ./facter.json;
    networking = {
      hostName = "storage";
      nameservers = [
        "192.168.248.2"
      ];
    };
    services = {
      samba = {
        enable = true;
        settings = {
          global = {
            "guest account" = "nobody";
            "hosts allow" = "192.168. 127.0.0.1 localhost";
            "hosts deny" = "0.0.0.0/0";
            "map to guest" = "bad user";
            security = "user";
            "usershare allow guests" = "yes";
            workgroup = "WORKGROUP";
          };
          data = {
            path = "/shares/data";
            browsable = true;
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = config.ironman.user.name;
            "force group" = config.ironman.user.name;
            "guest ok" = "yes";
            "read only" = "no";
          };
        };
      };
      samba-wsdd.enable = true;
      syncthing = {
        enable = true;
        cert = config.sops.secrets.syncthing_cert.path;
        dataDir = "/home/${config.ironman.user.name}";
        key = config.sops.secrets.syncthing_key.path;
        group = config.ironman.user.name;
        guiAddress = "0.0.0.0:8384";
        guiPasswordFile = config.sops.secrets.syncthing_password.path;
        settings = {
          folders = {
            "/shares/data/downloads/adult" = {
              devices = [
                "friday"
                "nas"
              ];
              id = "duytj-tdzw3";
              label = "adult";
            };
            "/shares/data/music" = {
              devices = [
                "friday"
                "wednesday"
              ];
              id = "6znxz-uhdps";
              label = "music";
              type = "sendonly";
            };
            "/shares/data/player-sync" = {
              id = "3gxrk-yv2vv";
              devices = [
                "friday"
                "M500_MIKU"
                "wednesday"
              ];
              label = "Player Sync";
            };
          };
          gui = {
            insecureAdminAccess = true;
            theme = "black";
          };
          options.urAccepted = -1;
        };
        user = config.ironman.user.name;
      };
    };
    sops.secrets =
      let
        group = config.ironman.user.name;
        sopsFile = "${self.outPath}/.secrets/hostStorage.yaml";
        owner = config.ironman.user.name;
        restartUnits = [ "syncthing.service" ];
      in
      {
        syncthing_cert = {
          inherit
            group
            sopsFile
            owner
            restartUnits
            ;
          mode = "0644";
        };
        syncthing_key = {
          inherit
            group
            sopsFile
            owner
            restartUnits
            ;
          mode = "0600";
        };
        syncthing_password = {
          inherit group owner restartUnits;
          sopsFile = "${self.outPath}/.secrets/syncthing.yaml";
        };
      };
    topology =
      let
        inherit (config.lib.topology) mkConnection;
      in
      {
        id = "storage";
        self = {
          interfaces.eth0 = {
            addresses = [
              "192.168.248.100"
            ];
            network = "home";
            physicalConnections = [
              (mkConnection "pve" "vmbr0")
            ];
          };
          deviceType = "nixos";
          guestType = "nixos-container";
          name = "Storage";
          parent = "pve";
        };
      };
  };
}
