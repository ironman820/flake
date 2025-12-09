{
  flake.nixosModules.de-lxqt =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        ayu-theme-gtk
        kdePackages.qtstyleplugin-kvantum
        unzip
        xarchiver
      ];
      security.pam.services.xscreensaver.enable = true;
      services = {
        displayManager.defaultSession = "lxqt";
        xserver = {
          enable = true;
          desktopManager.lxqt.enable = true;
          displayManager.lightdm.enable = true;
        };
      };
      xdg.portal.lxqt.enable = true;
    };
}
