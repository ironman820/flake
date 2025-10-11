{
  # config,
  lib,
  pkgs,
  ...
}: let
  # inherit (builtins) toString;
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
      # suidChroot
    ];
    mine = {
      networking.profiles.work = true;
      sops.secrets.nas_auth.sopsFile = ./secrets/secrets.yml;
      suites.laptop = enabled;
    };
    # fileSystems."/mnt/nas" = {
    #   device = "//192.168.254.5/Media";
    #   fsType = "cifs";
    #   options = let
    #     automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    #     gid = toString config.users.groups."users".gid;
    #     uid = toString config.users.users.${config.mine.user.name}.uid;
    #   in ["${automount_opts},credentials=${config.sops.secrets.nas_auth.path},uid=${uid},gid=${gid}"];
    # };
    system.stateVersion = "25.05";
  };
}
