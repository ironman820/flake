{ ... }:
{
  flake.nixosModules.de-plasma =
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs.kdePackages; [
      partitionmanager
    ];
    programs.kineticwe.enable = true;
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
    };
  };
}
