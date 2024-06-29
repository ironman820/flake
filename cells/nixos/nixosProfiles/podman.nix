{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  environment.systemPackages = with pkgs; [
    distrobox
    podman-compose
  ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket = l.enabled;
  };
}
