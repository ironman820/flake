{
  flake.nixosModules.virtual-docker =
    {
      config,
      pkgs,
      ...
    }:
    {
      users.users.${config.ironman.user.name}.extraGroups = [
        "docker"
      ];
      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };
    };
}
