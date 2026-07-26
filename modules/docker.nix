{
  flake.nixosModules.docker =
    {
      config,
      ...
    }:
    {
      users.users.${config.ironman.user.name}.extraGroups = [
        "docker"
      ];
      virtualisation.docker = {
        enable = true;
      };
    };
}
