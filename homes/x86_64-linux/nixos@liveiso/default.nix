{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  mine.home = {
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
