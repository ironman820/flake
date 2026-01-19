{ config, ... }:
{
  flake.nixosModules.de-plasma =
  { pkgs, ... }:
  {
    imports = with config.flake.nixosModules; [
      sddm
    ];
    environment.systemPackages = with pkgs.kdePackages; [
      partitionmanager
    ];
    programs.kdeconnect.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
