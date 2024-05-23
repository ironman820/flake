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
        hexchat = enabled;
      };
      suites.laptop = enabled;
      user.settings.stylix.image = ./ffvii.jpg;
      networking.profiles.work = true;
    };
    # boot.extraModprobeConfig = ''
    #   options iwlwifi 11n_disable=1 power_save=0
    #   options iwlmvm power_scheme=1
    #   options iwlwifi uapsd_disable=1
    # '';
    environment.systemPackages = [
      pkgs.devenv
    ];
    services.tlp.settings.RUNTIME_PM_DISABLE = "02:00.0";
    system.stateVersion = "23.05";
    zramSwap = enabled;
  };
}
