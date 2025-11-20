{
  flake.nixosModules.de-xfce =
    { pkgs, ... }:
    {
      boot.plymouth = {
        theme = "Chicago95";
        themePackages = [
          pkgs.local.chicago95
        ];
      };
      environment.systemPackages = with pkgs; [
        local.chicago95
        xfce.xfce4-whiskermenu-plugin
      ];
      programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-volman
          thunar-vcs-plugin
          thunar-archive-plugin
          thunar-media-tags-plugin
        ];
      };
      services = {
        displayManager.defaultSession = "xfce";
        xserver = {
          enable = true;
          desktopManager.xfce.enable = true;
          displayManager.lightdm = {
            enable = true;
            background = "#008080";
            greeters.gtk = {
              cursorTheme = {
                name = "Chicago95 Animated Hourglass";
                package = pkgs.local.chicago95;
              };
              iconTheme = {
                name = "Chicago95";
                package = pkgs.local.chicago95;
              };
            };
          };
        };
      };
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
}
