{
  flake.nixosModules.virtual-podman =
    {
      config,
      pkgs,
      ...
    }:
    {
      users.users.${config.ironman.user.name}.extraGroups = [
        "docker"
      ];
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        extraPackages = with pkgs; [
          distrobox
          podman-compose
        ];
      };
    };
}
