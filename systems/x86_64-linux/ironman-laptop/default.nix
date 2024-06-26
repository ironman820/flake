{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    (import ../../disko.nix
      {device = "/dev/nvme0n1";})
    ./hardware.nix
    ../../../common/drives/personal.nix
  ];

  config = {
    mine = {
      android = enabled;
      gui-apps.hexchat = enabled;
      suites.laptop = enabled;
      user.settings.stylix.image = ./ffvii.jpg;
      networking.profiles.work = true;
    };
    environment.systemPackages = [
      pkgs.devenv
    ];
    networking.networkmanager.wifi.scanRandMacAddress = false;
    services.tlp.settings.RUNTIME_PM_DISABLE = "02:00.0";
    system.stateVersion = "23.05";
    zramSwap = enabled;
  };
}
