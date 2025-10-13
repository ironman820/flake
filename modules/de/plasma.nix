{
  flake.nixosModules.de-plasma =
    { config, ... }:
    {
      services = {
        desktopManager.plasma6.enable = true;
      };
    };
}
