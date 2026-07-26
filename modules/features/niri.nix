{ self, ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    imports = with self.nixosModules; [
      noctalia
      noctalia-greeter
    ];
    environment.systemPackages = with pkgs; [
      gedit
      ghostty
      loupe
      nautilus
      nwg-look
      xwayland-satellite
    ];
    programs = {
      niri = {
        enable = true;
      };
      nm-applet.enable = true;
    };
    services = {
      logind.settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };
      upower.enable = true;
    };
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };
}
