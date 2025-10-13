{
  flake.nixosModules.networkmanager =
    {
      config,
      lib,
      ...
    }:
    {
        users.users.${config.ironman.user}.extraGroups = [ "networkmanager" ];
        networking.networkmanager.enable = lib.mkDefault true;
    };
}
