{
  flake.nixosModules.de-lxqt =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        unzip
        xarchiver
      ];
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
