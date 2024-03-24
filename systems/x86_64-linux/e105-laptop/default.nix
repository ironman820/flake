{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ./hardware.nix
    ../../../common/drives/work.nix
    ../../../common/drives/personal.nix
  ];

  config = {
    mine = {
      android = enabled;
      user.settings.stylix.image = ./voidbringer.png;
      suites.laptop = enabled;
      user.name = "niceastman";
      virtual = {
        host = enabled;
        podman = enabled;
      };
      work-tools = enabled;
      networking.profiles.work = true;
    };
    programs.usbtop = enabled;
    services.tlp.settings.RUNTIME_PM_DISABLE = "00:14.3";
    system.stateVersion = "23.05";
    zramSwap = enabled;
  };
}
