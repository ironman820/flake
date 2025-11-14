{
  flake.nixosModules.networking =
  { config, ... }:
  {
      networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      users.users.${config.ironman.user.name}.extraGroups = [ "networkmanager" ];
  };
}
