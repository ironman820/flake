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
      services = {
        displayManager.defaultSession = "xfce";
        xserver = {
          enable = true;
          desktopManager.xfce.enable = true;
          displayManager = {
            lightdm = {
              enable = true;
              greeters.gtk.theme = {
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
