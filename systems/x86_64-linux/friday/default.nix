{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ./hardware.nix
    ./disko.nix
  ];
  config = {
    environment.systemPackages = with pkgs; [
      cifs-utils
      enum4linux
      mmex
    ];
    mine = {
      networking.profiles.work = true;
      sops.secrets.nas_auth.sopsFile = ./secrets/secrets.yml;
      suites.laptop = enabled;
    };
    services.tlp.settings.RUNTIME_PM_DENYLIST = "03:00.0";
    system.stateVersion = "25.05";
  };
}
