{config, lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ../modules.nix
  ];
  mine.home = {
    neomutt.enable = true;
    suites.laptop = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
