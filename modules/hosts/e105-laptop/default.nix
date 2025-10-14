{
  config,
  ...
}:
{
  flake.nixosModules."hosts/e105-laptop" = {
    imports = with config.flake.nixosModules; [
      base
      config.flake.diskoConfigurations.e105-laptop
      drive-shares-personal
      intel-video
      laptop
      x64-linux
    ];
    facter.reportPath = ./facter.json;
    home-manager.users.niceastman = config.flake.homeConfigurations.niceastman;
    ironman = {
      user.name = "niceastman";
      network-profiles.work = true;
    };
    nix.settings.cores = 4;
    services.system76-scheduler.settings.cfsProfiles.enable = true;
  };
}
