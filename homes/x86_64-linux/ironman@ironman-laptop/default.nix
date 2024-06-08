{
  config,
  lib,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  mine.home = {
    suites.laptop = enabled;
    user.settings = {
      stylix = {
        fonts = {
          terminalSize = 10.0;
          waybarSize = 12;
        };
        image = ../../../systems/x86_64-linux/ironman-laptop/ffvii.jpg;
      };
      transparancy.terminalOpacity = 0.85;
    };
    waybar.resolution = 768;
  };
}
