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
  ])
  ++ (with self.nixosModules; [
    apps-gui-extra
    base
    boot-grub
    de-xfce
    fonts
    git
    self.diskoConfigurations.friday
    drive-shares
    drive-shares-personal
    laptop
    power
    tmux
    virtual-host
    virtual-docker
    winbox
    x64-linux
    yubikey
    (modulesPath + "/installer/scan/not-detected.nix")
  ]);
  environment.systemPackages = with pkgs; [
    calibre
    distrobox
    docker-compose
    freerdp
    mmex
  ];
  home-manager.users.ironman = self.homeConfigurations.ironman;
  ironman = {
    network-profiles.work = true;
    syncthing = {
      devices = {
        work = {
          id = "BBFLUDI-YSDBEJF-TALS6VU-ETJ2PHU-WNXBHUG-JXPCEU4-NO2IQNE-YRWAUQX";
          name = "Work Laptop";
        };
      };
      folders = {
        "/home/${config.ironman.user.name}/Documents" = {
          id = "wcn42-ot2xw";
          devices = [
            "nas"
          ];
          label = "Documents";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "/home/${config.ironman.user.name}/Downloads" = {
          id = "zuqju-kwzbp";
          devices = [
            "nas"
          ];
          label = "Downloads";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "/home/${config.ironman.user.name}/Calibre Library" = {
          id = "eirgv-qg2rc";
          devices = [
            "nas"
          ];
          label = "Calibre Library";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "/home/${config.ironman.user.name}/Money" = {
          id = "wsrp4-mckub";
          devices = [
            "nas"
            "phone"
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
        "/home/${config.ironman.user.name}/Pictures" = {
          id = "sxb6h-chv5s";
          devices = [
            "nas"
          ];
          label = "Pictures";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "/home/${config.ironman.user.name}/Work/Documents" = {
          id = "kuriw-survq";
          devices = [
            "nas"
          ];
          label = "Work Documents";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
        "/home/${config.ironman.user.name}/Work/Pictures" = {
          id = "okbn5-ywkrq";
          devices = [
            "nas"
          ];
          label = "Work Pictures";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
      };
    };
  };
  networking.hostName = "friday";
  nix.settings.cores = 4;
  services.tlp.settings.RUNTIME_PM_DENYLIST = "03:00.0";
}
