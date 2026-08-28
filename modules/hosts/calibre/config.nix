{
  self,
  ...
}:
{
  flake.nixosModules.calibreConfig =
    { config, ... }:
    {
      hardware.facter.reportPath = ./facter.json;
      networking = {
        defaultGateway.address = "192.168.248.1";
        hostName = "calibre";
        interfaces.eth0.ipv4.addresses = [
          {
            address = "192.168.248.101";
            prefixLength = 23;
          }
        ];
        nameservers = [
          "192.168.248.2"
        ];
      };
      proxmoxLXC.manageNetwork = true;
      services = {
        calibre-web = {
          enable = true;
          group = config.ironman.user.name;
          listen.ip = "0.0.0.0";
          openFirewall = true;
          options.calibreLibrary = "/data/books";
          user = config.ironman.user.name;
        };
        syncthing = {
          enable = true;
          cert = config.sops.secrets.syncthing-calibre-cert.path;
          group = config.ironman.user.name;
          guiAddress = "0.0.0.0:8384";
          key = config.sops.secrets.syncthing-calibre-key.path;
          openDefaultPorts = true;
          settings = {
            devices = {
              friday.id = "C2T72DJ-35SQ4DJ-OTQFZUH-R54J3FK-7K2M46K-RAN5SFU-4Y4ZNIL-FZ64AQQ";
              nas.id = "MAJ6SK3-COCJQMB-BUCAUK5-KNIQPBP-2HCZLDM-Y52DUGR-CUQLSUV-ST3B7AQ";
            };
            folders.books = {
              devices = [
                "friday"
                "nas"
              ];
              id = "eirgv-qg2rc";
              path = "/data/books";
            };
            options.urAccepted = -1;
          };
          user = config.ironman.user.name;
        };
      };
      sops.secrets =
        let
          group = config.ironman.user.name;
          mode = "0440";
          owner = config.ironman.user.name;
          sopsFile = "${self.outPath}/.secrets/syncthing.yaml";
        in
        {
          syncthing-calibre-cert = {
            inherit
              group
              mode
              owner
              sopsFile
              ;
          };
          syncthing-calibre-key = {
            inherit
              group
              mode
              owner
              sopsFile
              ;
          };
        };
      topology.self = {
        deviceType = "nixos";
        guestType = "nixos-container";
        interfaces.eth0 = {
          network = "home";
          physicalConnections = [
            (config.lib.topology.mkConnection "pve" "vmbr0")
          ];
          virtual = true;
        };
        name = "Calibre";
        parent = "pve";
        services.calibre-web = {
          icon = "services.calibreweb";
          info = "https://mybooks.niceastman.com";
          name = "Calibre-Web";
        };
      };
    };
}
