{
  flake.nixosModules.virtual-podman =
{
  pkgs,
  ...
}: {
    environment.systemPackages = with pkgs; [
      distrobox
      podman-compose
    ];
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
}
