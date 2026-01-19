{
  config,
  flakeRoot,
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
  ])
  ++ (with self.nixosModules; [
    apps-gui-extra
    apps-python
    base
    boot-grub
    de-plasma
    fonts
    git
    self.diskoConfigurations.e105-laptop
    drive-shares
    drive-shares-work
    drive-shares-personal
    intel-video
    laptop
    # TODO: Troubleshooting crashes disable power management
    # power
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
    deskflow
    distrobox
    docker-compose
    googleearth-pro
    freerdp
  ];
  home-manager.users.niceastman = self.homeConfigurations.niceastman;
  ironman = {
    syncthing = {
      cert = config.sops.secrets.syncthing-work-cert.path;
      key = config.sops.secrets.syncthing-work-key.path;
      devices = {
        friday = {
          id = "C2T72DJ-35SQ4DJ-OTQFZUH-R54J3FK-7K2M46K-RAN5SFU-4Y4ZNIL-FZ64AQQ";
          name = "Friday";
        };
      };
      folders = {
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
    hostName = "e105-laptop";
  };
  nix.settings.cores = 4;
  services.system76-scheduler.settings.cfsProfiles.enable = true;
  sops.secrets =
    let
      group = config.ironman.user.name;
      mode = "0440";
      owner = config.ironman.user.name;
      sopsFile = "${flakeRoot}/.secrets/syncthing.yaml";
    in
    {
      syncthing-work-cert = {
        inherit
          group
          mode
          owner
          sopsFile
          ;
      };
      syncthing-work-key = {
        inherit
          group
          mode
          owner
          sopsFile
          ;
      };
    };
  # TODO: Troubleshoot crashes. disable ZRAM
  zramSwap.enable = false;
}
