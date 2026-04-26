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
    nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
  ])
  ++ (with self.nixosModules; [
    apps-gui-extra
    base
    boot-grub
    de-plasma
    fonts
    git
    self.diskoConfigurations.friday
    drive-shares
    drive-shares-personal
    laptop
    # power
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
      cert = config.sops.secrets.syncthing-friday-cert.path;
      key = config.sops.secrets.syncthing-friday-key.path;
      devices = {
        calibre.id = "J3LVEJP-XUTHFQ2-2W5U22G-JLDNUL2-S3GC4GW-VVQOY7Q-N6SFPJT-REN45AO";
        wednesday.id = "ICGQ6GR-GFFLBJB-N4AF3AP-IOSLCHN-337F5UX-RW2A35G-UZ3Q2N4-SVWXTQY";
        work = {
          id = "RPVYMOE-RC2NDFN-C5TRBZ2-ATRNVNE-VWONQD3-DVAGPJ5-OV5RWTK-KKKBSAI";
          name = "Work Laptop";
        };
        steamdeck = {
          id = "NHY6BAU-WXMQZC2-CZP7P7Z-N5VZQIS-WI5P5L5-R2K2VOL-QYJG4NX-FNH5OA7";
          name = "SteamDeck";
        };
      };
      folders = {
        "/home/${config.ironman.user.name}/.var/app/com.orcaslicer.OrcaSlicer/config/OrcaSlicer" = {
          id = "eubqq-hp2qx";
          devices = [
            "nas"
            "wednesday"
          ];
          label = "OrcaSlicer";
        };
        "/home/${config.ironman.user.name}/Deck Sync" = {
          id = "oz0sn-2p90q";
          devices = [
            "nas"
            "steamdeck"
          ];
          label = "Deck Sync";
        };
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
            "wednesday"
            "work"
            "work-desktop"
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
            "calibre"
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
        "/home/${config.ironman.user.name}/Notes" = {
          id = "q6twd-r4s4f";
          devices = [
            "nas"
            "phone"
            "wednesday"
            "work"
          ];
          label = "Notes";
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
            "wednesday"
            "work"
            "work-desktop"
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
            "wednesday"
            "work"
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
            "nas"
            "wednesday"
            "work"
            "work-desktop"
          ];
          label = "Wallpapers";
        };
      };
    };
  };
  networking.hostName = "friday";
  nix.settings.cores = 4;
  services.openssh.settings.PermitRootLogin = "no";
  # services.tlp.settings.RUNTIME_PM_DENYLIST = "03:00.0";
  sops.secrets =
    let
      group = config.ironman.user.name;
      mode = "0440";
      owner = config.ironman.user.name;
      sopsFile = "${flakeRoot}/.secrets/syncthing.yaml";
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
}
