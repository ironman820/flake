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
        easyaudiosync
        freefilesync
        freerdp
        kcc
        kdePackages.kdenlive
        mmex
        nix-tree
      ];
      hardware.facter.reportPath = ./facter.json;
      ironman = {
        network-profiles.work = true;
        shares.personal = true;
        sync = true;
        syncthing = {
          cert = config.sops.secrets.syncthing-friday-cert.path;
          key = config.sops.secrets.syncthing-friday-key.path;
          devices = {
            saturday.id = "6DKKXPD-O4IJK3G-VR2MTOR-FCXWIAV-ZLETO3O-ZCINEWD-AMKXHWZ-JIVGPQJ";
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
              "/home/${name}/Adult" = {
                id = "duytj-tdzw3";
                devices = [
                  "nas"
                  "storage"
                ];
                label = "Adult";
                minDiskFree = {
                  unit = "%";
                  value = 10;
                };
                order = "alphabetic";
              };
              "/home/${name}/Deck Sync" = {
                id = "oz0sn-2p90q";
                devices = [
                  "nas"
                  "saturday"
                ];
                label = "Deck Sync";
              };
              "/home/${name}/Documents" = {
                id = "wcn42-ot2xw";
                devices = [
                  "nas"
                ];
                label = "Documents";
              };
              "/home/${name}/Downloads" = {
                id = "zuqju-kwzbp";
                devices = [
                  "nas"
                  "wednesday"
                  "work-desktop"
                ];
                label = "Downloads";
              };
              "/home/${name}/Books" = {
                id = "eirgv-qg2rc";
                devices = [
                  "nas"
                  "storage"
                ];
                label = "Books";
              };
              "/home/${name}/Money" = {
                id = "wsrp4-mckub";
                devices = [
                  "nas"
                  "wednesday"
                ];
                label = "Money";
              };
              "/home/${name}/Music" = {
                id = "6znxz-uhdps";
                devices = [
                  "nas"
                  "storage"
                ];
                label = "Music";
                type = "receiveonly";
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
              };
              "/home/${name}/player-sync" = {
                id = "3gxrk-yv2vv";
                devices = [
                  "M500_MIKU"
                  "storage"
                  "wednesday"
                ];
                label = "Player Sync";
              };
              "/home/${name}/Work/Documents" = {
                id = "kuriw-survq";
                devices = [
                  "nas"
                  "wednesday"
                  "work-desktop"
                ];
                label = "Work Documents";
              };
              "/home/${name}/Work/Pictures" = {
                id = "okbn5-ywkrq";
                devices = [
                  "nas"
                  "wednesday"
                  "work-desktop"
                ];
                label = "Work Pictures";
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
      programs = {
        # hopmatrix.enable = true;
        steam = {
          enable = true;
          protontricks.enable = true;
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
