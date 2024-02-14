{ lib, ... }:
let inherit (lib.mine) enabled;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  mine.home = {
    programs = { ranger = enabled; };
    sops.install = true;
    suites.server = enabled;
  };
}
