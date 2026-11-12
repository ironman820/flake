{
  flake.nixosModules.docker =
    {
      config,
      pkgs,
      ...
    }:
    {
      boot.enableContainers = true;
      environment.systemPackages = [
        pkgs.docker-compose
      ];
      users.users.${config.ironman.user.name}.extraGroups = [
        "docker"
      ];
      virtualisation.docker = {
        enable = true;
      };
    };
}
