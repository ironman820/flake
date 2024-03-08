{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports = [
    ./hardware.nix
  ];

  config = {
    mine = {
      hyprland.enable = mkForce false;
      sops.secrets.nas_auth.sopsFile = ./secrets/secrets.yml;
      suites.virtual-workstation.enable = true;
    };
    environment.systemPackages = [
      pkgs.cifs-utils
    ];
    fileSystems."/run/media/${config.mine.user.name}" = {
      device = "//192.168.254.252/volume1/Media";
      fsType = "cifs";
      options = let
        inherit (config.users.users.${config.mine.user.name}) uid;
        inherit (config.users.groups."users") gid;
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in ["${automount_opts},credentials=${config.sops.secrets.nas_auth.path},uid=${uid},gid=${gid}"];
    };
    system.stateVersion = "23.05";
  };
}
