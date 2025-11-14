{
  flake.nixosModules.de-xfce =
    { config, pkgs, ... }:
    {
      # environment.systemPackages = with pkgs; [
      #   chicago95
      # ];
      services.xserver = {
        enable = true;
        desktopManager.xfce.enable = true;
        displayManager.lightdm.enable = true;
      };
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
}
