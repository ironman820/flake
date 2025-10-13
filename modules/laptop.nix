{ config, ... }:
{
  flake.nixosModules.laptop = {pkgs, ...}: {
    imports = with config.flake.nixosModules; [
      apps-gui
      de-plasma
      drive-shares
      firmware
      gpg
      networkmanager
      network-profiles
      power
      resilio
      sddm
      sound
      virtual-host
      virtual-podman
      yubikey
    ];
    hardware.bluetooth.enable = true;
    programs = {
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
    zramSwap.enable = true;
  };
}
