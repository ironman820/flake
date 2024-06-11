{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  v = config.vars;
  p = inputs.cells.mine.packages;
in {
  environment.systemPackages = [
    p.networkmanagerapplet
  ];
  users.users.${v.username}.extraGroups = ["networkmanager"];
  networking.networkmanager = l.enabled;
}
