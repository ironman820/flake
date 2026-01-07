{
  flake.nixosModules.de-xfce =
    { pkgs, ... }:
    {
      environment.systemPackages =
        (with pkgs; [
          blueman
          local.bonafides-gtk-themes
          gnome-disk-utility
          file-roller
          font-manager
          libqalculate
          orca
          pavucontrol
          qalculate-gtk
          unzip
          wmctrl
          xarchiver
          xclip
          xcolor
          xdo
          xdotool
          xfce4-clipman-plugin
          xfce4-cpugraph-plugin
          xfce4-fsguard-plugin
          xfce4-genmon-plugin
          xfce4-netload-plugin
          xfce4-panel
          xfce4-pulseaudio-plugin
          xfce4-systemload-plugin
          xfce4-weather-plugin
          xfce4-whiskermenu-plugin
          xfce4-xkb-plugin
          xorg.xev
          xsel
          xtitle
          xwinmosaic
          catfish
          gigolo
          orage
          xfce4-appfinder
          xfce4-dict
          xfdashboard
        ]);
      programs = {
        dconf.enable = true;
        thunar = {
          enable = true;
          plugins = with pkgs; [
            thunar-volman
            thunar-vcs-plugin
            thunar-archive-plugin
            thunar-media-tags-plugin
          ];
        };
      };
      security.pam.services.gdm.enableGnomeKeyring = true;
      services = {
        blueman.enable = true;
        displayManager.defaultSession = "xfce";
        xserver = {
          enable = true;
          desktopManager.xfce.enable = true;
          displayManager.lightdm = {
            enable = true;
          };
        };
      };
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
}
