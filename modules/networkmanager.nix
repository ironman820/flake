{
  flake.nixosModules.networkmanager =
    {
      config,
      lib,
      ...
    }:
    {
        users.users.${config.ironman.user.name}.extraGroups = [ "networkmanager" ];
        networking.networkmanager.enable = lib.mkDefault true;
    };
}
