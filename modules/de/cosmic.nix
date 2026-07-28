{
  flake.nixosModules.de-cosmic =
    { ... }:
    {
      services = {
        desktopManager.cosmic.enable = true;
        displayManager.cosmic-greeter.enable = true;
        system76-scheduler.enable = true;
      };
    };
}
