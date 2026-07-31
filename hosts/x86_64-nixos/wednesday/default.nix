{
  config,
  inputs,
  modulesPath,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with inputs; [
    darkmatter-grub-theme.nixosModule
    disko.nixosModules.disko
    nixos-hardware.nixosModules.framework-amd-ai-300-series
  ])
  ++ (with self.nixosModules; [
    apps-gui-extra
    apps-python
    arduino
    base
    boot-grub
    de-cosmic
    fonts
    git
    self.diskoConfigurations.wednesday
    drive-shares
    drive-shares-work
    drive-shares-personal
    intel-video
    laptop
    syncthing
    tmux
    virtual-host
    virtual-docker
    winbox
    x64-linux
    yubikey
    (modulesPath + "/installer/scan/not-detected.nix")
  ]);
  environment.systemPackages = with pkgs; [
    boxbuddy
    deskflow
    distrobox
    docker-compose
    googleearth-pro
    freerdp
  ];
  home-manager.users.niceastman = self.homeConfigurations.niceastman;
  ironman = {
    syncthing = {
      devices = {
        friday = {
          id = "C2T72DJ-35SQ4DJ-OTQFZUH-R54J3FK-7K2M46K-RAN5SFU-4Y4ZNIL-FZ64AQQ";
          name = "Friday";
        };
      };
      folders = {
        "/home/${config.ironman.user.name}/.var/app/com.orcaslicer.OrcaSlicer/config/OrcaSlicer" = {
          id = "eubqq-hp2qx";
          devices = [
            "nas"
            "friday"
          ];
          label = "OrcaSlicer";
        };
        "/home/${config.ironman.user.name}/.thunderbird" = {
          id = "upryn-vzhy9";
          devices = [
            "nas"
          ];
          label = "Thunderbird";
          type = "sendonly";
        };
        "/home/${config.ironman.user.name}/Downloads" = {
          id = "zuqju-kwzbp";
          devices = [
            "friday"
            "nas"
            "work-desktop"
          ];
          label = "Downloads";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "/home/${config.ironman.user.name}/Documents" = {
          id = "kuriw-survq";
          devices = [
            "friday"
            "nas"
            "work-desktop"
          ];
          label = "Work Documents";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "/home/${config.ironman.user.name}/Notes" = {
          id = "q6twd-r4s4f";
          devices = [
            "friday"
            "nas"
            "phone"
          ];
          label = "Notes";
        };
        "/home/${config.ironman.user.name}/Pictures" = {
          id = "okbn5-ywkrq";
          devices = [
            "friday"
            "nas"
            "work-desktop"
          ];
          label = "Work Pictures";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "/home/${config.ironman.user.name}/Wallpapers" = {
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
    network-profiles.work = true;
  };
  networking = {
    firewall.allowedTCPPorts = [
      24800
    ];
    hostName = "wednesday";
  };
  nix.settings.cores = 4;
  services = {
    openssh.settings.PermitRootLogin = "no";
  };
}
