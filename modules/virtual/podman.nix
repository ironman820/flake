{
  flake.nixosModules.virtual-podman =
{
  config,
  pkgs,
  ...
}: {
    environment.systemPackages = with pkgs; [
      distrobox
      podman-compose
    ];
    users.users.${config.ironman.user.name}.extraGroups = [
      "docker"
    ];
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
}
