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
    # TODO: replace with the correct scan from friday
    facter.reportPath = ./facter.json;
    ironman.network-profiles.work = true;
    # mine = {
    #   networking.profiles.work = true;
    #   sops.secrets.nas_auth.sopsFile = ./secrets/secrets.yml;
    #   suites.laptop = enabled;
    # };
    nix.settings.cores = 4;
    services.system76-scheduler.settings.cfsProfiles.enable = true;
  };
}
