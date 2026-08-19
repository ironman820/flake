{ self, ... }:
{
  flake.nixosModules.laptop =
    { lib, pkgs, ... }:
    let
      inherit (lib) mkDefault;
    in
    {
      imports = with self.nixosModules; [
        guiApps
        firmware
        networking
        network-profiles
        sound
      ];
      environment.systemPackages = with pkgs; [
        caligula
        deploy-rs
        ffmpeg
        graphicsmagick
        gns3-gui
        hplip
        self.packages.${pkgs.stdenv.hostPlatform.system}.idracclient
        poppler-utils
        # protonplus
        wireguard-tools
      ];
      hardware.bluetooth.enable = true;
      programs = {
        gnupg.agent = {
          enableSSHSupport = mkDefault false;
          enable = true;
        };
        system-config-printer.enable = true;
      };
      services = {
        avahi.enable = true;
        flatpak.enable = true;
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
      zramSwap.enable = mkDefault true;
    };
}
