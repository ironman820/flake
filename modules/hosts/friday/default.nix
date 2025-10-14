{
  config,
  ...
}:
{
  flake.nixosModules."hosts/friday" = {pkgs, ...}: {
    imports = with config.flake.nixosModules; [
      base
      config.flake.diskoConfigurations.friday
      drive-shares-personal
      laptop
      x64-linux
    ];
    environment.systemPackages = with pkgs; [
      calibre
      mmex
    ];
    facter.reportPath = ./facter.json;
    home-manager.users.ironman = config.flake.homeConfigurations.user-ironman;
    ironman.network-profiles.work = true;
    nix.settings.cores = 4;
    services.tlp.settings.RUNTIME_PM_DENYLIST = "03:00.0";
  };
}
