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
        phone.id = "YEXTAE5-7ZTCY7M-ZXBBE7Z-LO3GXUV-XIHCFDJ-SBDPV22-VJEOUDJ-QO7GGQG";
        work = {
          id = "RPVYMOE-RC2NDFN-C5TRBZ2-ATRNVNE-VWONQD3-DVAGPJ5-OV5RWTK-KKKBSAI";
          name = "Work Laptop";
        };
        steamdeck = {
          id = "MH5QWUV-EYRW4KY-FEBPNMY-Q52YRGD-ZS3Y5IC-XSOMENJ-FOLT6BF-2PG2DAY";
          name = "SteamDeck";
        };
      };
      folders = {
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
        "/home/${config.ironman.user.name}/Notes" = {
          id = "q6twd-r4s4f";
          devices = [
            "nas"
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
