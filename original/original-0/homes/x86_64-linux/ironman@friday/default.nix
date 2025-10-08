{config, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ../modules.nix
  ];
  mine.home = {
    suites.laptop = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
