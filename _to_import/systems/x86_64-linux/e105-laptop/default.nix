{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ./disko.nix
    ./hardware.nix
    # ../../../common/drives/work.nix
    # ../../../common/drives/personal.nix
  ];

  config = {
    mine = {
      user.settings.stylix.image = ./voidbringer.png;
      suites.laptop = enabled;
      user.name = "niceastman";
      networking.profiles.work = true;
    };
    services.tlp.settings.RUNTIME_PM_DISABLE = "00:14.3";
    system.stateVersion = "25.05";
    zramSwap = enabled;
  };
}
