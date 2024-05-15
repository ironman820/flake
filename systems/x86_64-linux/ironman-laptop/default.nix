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
      gui-apps = {
        contour = enabled;
        hexchat = enabled;
      };
      impermanence = enabled;
      sops.age.keyFile = "/persist/root/etc/nixos/keys.txt";
      suites.laptop = enabled;
      user.settings.stylix.image = ./ffvii.jpg;
      networking.profiles.work = true;
    };
    environment.systemPackages = [
      pkgs.devenv
    ];
    services.tlp.settings.RUNTIME_PM_DISABLE = "02:00.0";
    system.stateVersion = "23.05";
    zramSwap = enabled;
  };
}
