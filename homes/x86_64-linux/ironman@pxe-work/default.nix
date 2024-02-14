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
    suites.server = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
