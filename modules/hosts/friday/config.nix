{ self, ... }: {
  flake.nixosModules.fridayConfig =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        calibre
        distrobox
        docker-compose
        freerdp
        mmex
      ];
      hardware.facter.reportPath = ./facter.json;
      ironman = {
        network-profiles.work = true;
        shares.personal = true;
        syncthing = {
          cert = config.sops.secrets.syncthing-friday-cert.path;
          key = config.sops.secrets.syncthing-friday-key.path;
          devices = {
            calibre.id = "J3LVEJP-XUTHFQ2-2W5U22G-JLDNUL2-S3GC4GW-VVQOY7Q-N6SFPJT-REN45AO";
            wednesday.id = "ICGQ6GR-GFFLBJB-N4AF3AP-IOSLCHN-337F5UX-RW2A35G-UZ3Q2N4-SVWXTQY";
            steamdeck = {
              id = "NHY6BAU-WXMQZC2-CZP7P7Z-N5VZQIS-WI5P5L5-R2K2VOL-QYJG4NX-FNH5OA7";
              name = "SteamDeck";
            };
          };
          folders =
            let
              inherit (config.ironman.user) name;
            in
            {
              "/home/${name}/.var/app/com.orcaslicer.OrcaSlicer/config/OrcaSlicer" = {
                id = "eubqq-hp2qx";
                devices = [
                  "nas"
                  "wednesday"
                ];
                label = "OrcaSlicer";
              };
              "/home/${name}/Deck Sync" = {
                id = "oz0sn-2p90q";
                devices = [
                  "nas"
                  "steamdeck"
                ];
                label = "Deck Sync";
              };
              "/home/${name}/Documents" = {
                id = "wcn42-ot2xw";
                devices = [
                  "nas"
                ];
                label = "Documents";
                versioning = {
                  type = "simple";
                  params = {
                    cleanoutDays = "7";
                    keep = "10";
                  };
                };
              };
              "/home/${name}/Downloads" = {
                id = "zuqju-kwzbp";
                devices = [
                  "nas"
                  "wednesday"
                  "work-desktop"
                ];
                label = "Downloads";
                versioning = {
                  type = "simple";
                  params = {
                    cleanoutDays = "7";
                    keep = "10";
                  };
                };
              };
              "/home/${name}/Calibre Library" = {
                id = "eirgv-qg2rc";
                devices = [
                  "calibre"
                  "nas"
                ];
                label = "Calibre Library";
                versioning = {
                  type = "simple";
                  params = {
                    cleanoutDays = "7";
                    keep = "10";
                  };
                };
              };
              "/home/${name}/Money" = {
                id = "wsrp4-mckub";
                devices = [
                  "nas"
                ];
                label = "Money";
                versioning = {
                  type = "staggered";
                  params = {
                    cleanInterval = "3600";
                    maxAge = "31536000";
                  };
                };
              };
              "/home/${name}/Notes" = {
                id = "q6twd-r4s4f";
                devices = [
                  "nas"
                  "phone"
                  "wednesday"
                ];
                label = "Notes";
              };
              "/home/${name}/Pictures" = {
                id = "sxb6h-chv5s";
                devices = [
                  "nas"
                ];
                label = "Pictures";
                versioning = {
                  type = "simple";
                  params = {
                    cleanoutDays = "7";
                    keep = "10";
                  };
                };
              };
              "/home/${name}/Work/Documents" = {
                id = "kuriw-survq";
                devices = [
                  "nas"
                  "wednesday"
                  "work-desktop"
                ];
                label = "Work Documents";
                versioning = {
                  type = "simple";
                  params = {
                    cleanoutDays = "7";
                    keep = "10";
                  };
                };
              };
              "/home/${name}/Work/Pictures" = {
                id = "okbn5-ywkrq";
                devices = [
                  "nas"
                  "wednesday"
                  "work-desktop"
                ];
                label = "Work Pictures";
                versioning = {
                  type = "simple";
                  params = {
                    cleanoutDays = "7";
                    keep = "10";
                  };
                };
              };
              "/home/${name}/Wallpapers" = {
                id = "gtwyq-tfzfb";
                devices = [
                  "nas"
                  "wednesday"
                  "work-desktop"
                ];
                label = "Wallpapers";
              };
            };
        };
      };
      networking.hostName = "friday";
      nix.settings.cores = 5;
      programs.steam = {
        enable = true;
        protontricks.enable = true;
      };
      sops.secrets =
        let
          group = config.ironman.user.name;
          mode = "0440";
          owner = config.ironman.user.name;
          sopsFile = "${self.outPath}/.secrets/syncthing.yaml";
        in
        {
          syncthing-friday-cert = {
            inherit
              group
              mode
              owner
              sopsFile
              ;
          };
          syncthing-friday-key = {
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
        hardware.info = "Lenovo Thinkpad E14";
        icon = "devices.laptop";
        interfaces.wlp3s0 = {
          network = "home";
          renderer.hidePhysicalConnections = true;
          sharesNetworkWith = [
            (lib.const true)
          ];
        };
        name = "Friday";
      };
      users.groups.ironman.gid = lib.mkForce 986;
    };
}
