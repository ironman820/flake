{ config, pkgs, ... }: {
  environment.systemPackages = [
    pkgs.googleearth-pro
  ];
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    extraGui = true;
    flatpaks = [
      "com.anydesk.Anydesk"
    ];
    network-profiles.work = true;
    shares = {
      personal = true;
      work = true;
    };
    syncthing = {
      devices = {
        friday = {
          id = "C2T72DJ-35SQ4DJ-OTQFZUH-R54J3FK-7K2M46K-RAN5SFU-4Y4ZNIL-FZ64AQQ";
          name = "Friday";
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
              "friday"
            ];
            label = "OrcaSlicer";
          };
          "/home/${name}/.thunderbird" = {
            id = "upryn-vzhy9";
            devices = [
              "nas"
            ];
            label = "Thunderbird";
            type = "sendonly";
          };
          "/home/${name}/Downloads" = {
            id = "zuqju-kwzbp";
            devices = [
              "friday"
              "nas"
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
          "/home/${name}/Documents" = {
            id = "kuriw-survq";
            devices = [
              "friday"
              "nas"
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
          "/home/${name}/Notes" = {
            id = "q6twd-r4s4f";
            devices = [
              "friday"
              "nas"
              "phone"
            ];
            label = "Notes";
          };
          "/home/${name}/Pictures" = {
            id = "okbn5-ywkrq";
            devices = [
              "friday"
              "nas"
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
              "friday"
              "nas"
              "work-desktop"
            ];
            label = "Wallpapers";
          };
        };
    };
    user = {
      name = "niceastman";
      email = {
        bob = "nic.eastman";
        site = "royell.org";
      };
    };
    workWorkstation = true;
  };
  networking = {
    firewall.allowedTCPPorts = [
      24800
    ];
    hostName = "wednesday";
  };
  nix.settings.cores = 4;
  topology.self = {
    deviceType = "nixos";
    hardware.info = "Framework Laptop 13 (AMD Ryzen AI 300 Series)";
    icon = "devices.laptop";
    interfaces = {
      enp195s0f0u2 = {
        network = "work";
        renderer.hidePhysicalConnections = true;
        sharesNetworkWith = [
          (wlp192s0: true)
        ];
      };
      wlp192s0.renderer.hidePhysicalConnections = true;
    };
    name = "Wednesday";
  };
}
