{ config, ... }:
{
  flake.nixosModules.laptop =
    { lib, pkgs, ... }:
    let
      inherit (lib) mkDefault;
    in
    {
      imports = with config.flake.nixosModules; [
        apps-gui
        firmware
        networking
        network-profiles
        sound
      ];
      hardware.bluetooth.enable = true;
      programs = {
        gnupg.agent = {
          enableSSHSupport = mkDefault false;
          enable = true;
        };
        steam.enable = true;
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
