{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.laptop = moduleWithSystem (
    perSystem@{ self', ... }: { lib, pkgs, ... }: {
      imports = (
        with self.nixosModules;
        [
          core
          docker
          driveShares
          firmware
          flatpak
          ghostty
          gpg
          guiApps
          networkManager
          networkProfiles
          plasma
          sound
          syncthing
          virtualHost
          winbox
          yubikey
        ]
      );
      environment.systemPackages = with pkgs; [
        caligula
        deploy-rs
        fetch
        ffmpeg
        freerdp
        graphicsmagick
        gns3-gui
        hplip
        self'.packages.idracclient
        poppler-utils
        wireguard-tools
      ];
      hardware.bluetooth.enable = true;
      ironman = {
        extraGui = true;
        laptop = true;
      };
      nix = {
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        optimise.automatic = true;
        settings.auto-optimise-store = true;
      };
      programs.system-config-printer.enable = true;
      services = {
        avahi.enable = true;
        logind.settings.Login = {
          KillUserProcesses = true;
          HandleLidSwitchExternalPower = "ignore";
        };
        printing = {
          enable = true;
          cups-pdf.enable = true;
          drivers = with pkgs; [
            gutenprint
            hplip
          ];
        };
        udisks2.enable = true;
      };
      systemd.settings.Manager = {
        DefaultTimeoutStopSec = "10s";
      };
      zramSwap.enable = lib.mkDefault true;
    }
  );
}
