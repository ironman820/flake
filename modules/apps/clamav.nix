{
  flake.nixosModules.apps-clamav =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.clamtk
      ];
      services.clamav = {
        daemon.enable = true;
        fangfrisch.enable = true;
        updater.enable = true;
      };
    };
}
