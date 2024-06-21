{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    dmenu
    feh
    networkmanager_dmenu
    picom
  ];
  services.xserver = {
    enable = true;
    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oa: {
        src = inputs.ironman-dwm;
      });
    };
  };
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
}
