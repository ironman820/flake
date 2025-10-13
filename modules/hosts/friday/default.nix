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
    ironman.network-profiles.work = true;
    # mine = {
    #   sops.secrets.nas_auth.sopsFile = ./secrets/secrets.yml;
    # };
    nix.settings.cores = 4;
    services.tlp.settings.RUNTIME_PM_DENYLIST = "03:00.0";
  };
}
