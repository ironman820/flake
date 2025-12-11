{
  flake.nixosModules.de-lxqt =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        ayu-theme-gtk
        xfce.mousepad
        networkmanagerapplet
        kdePackages.qtstyleplugin-kvantum
        unzip
        xarchiver
      ];
      programs.nm-applet.enable = true;
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
