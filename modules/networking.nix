{
  flake.nixosModules.networking =
  { config, ... }:
  {
      networking.networkmanager = {
        enable = true;
      };
      users.users.${config.ironman.user.name}.extraGroups = [ "networkmanager" ];
  };
}
