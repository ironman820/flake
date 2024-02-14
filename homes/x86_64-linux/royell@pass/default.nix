{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
let
  inherit (lib.mine) enabled;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  mine.home = {
    programs.ranger = enabled;
    suites.server = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
