{
  flake.nixosModules.de-xfce =
    { pkgs, ... }:
    {
      environment = {
        systemPackages =
        (with pkgs; [
          blueman
          catfish
          local.bonafides-gtk-themes
          file-roller
          font-manager
          gigolo
          gnome-disk-utility
          libqalculate
          orca
          pavucontrol
          qalculate-gtk
          unzip
          wmctrl
          orage
          xarchiver
          xclip
          xcolor
          xdo
          xdotool
          xev
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
          xfce4-appfinder
          xfce4-dict
          xfdashboard
          xsel
          xtitle
          xwinmosaic
        ]);
        xfce.excludePackages = with pkgs; [
          xfce4-terminal
        ];
      };
      nixpkgs.config.pulseaudio = true;
      programs = {
        dconf.enable = true;
        thunar = {
          enable = true;
          plugins = with pkgs; [
            thunar-archive-plugin
            thunar-media-tags-plugin
            thunar-vcs-plugin
            thunar-volman
          ];
        };
      };
      security.pam.services.gdm.enableGnomeKeyring = true;
      services = {
        blueman.enable = true;
        displayManager.defaultSession = "xfce";
        gnome.gnome-keyring.enable = true;
        xserver = {
          enable = true;
          desktopManager = {
            xfce = {
              enable = true;
              enableScreensaver = false;
            };
            xterm.enable = false;
          };
          displayManager.lightdm = {
            enable = true;
          };
          excludePackages = [ pkgs.xterm ];
        };
      };
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
}
