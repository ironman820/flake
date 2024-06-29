{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  v = config.vars;
in {
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
  users.users.${v.username}.extraGroups = [
    "docker"
  ];
  virtualisation.docker = l.enabled;
}
