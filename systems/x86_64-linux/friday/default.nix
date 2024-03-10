{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) toString;
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
    environment.systemPackages = with pkgs; [
      cifs-utils
      enum4linux
      suidChroot
    ];
    fileSystems."/mnt/nas" = {
      device = "//192.168.254.252/Media";
      fsType = "cifs";
      options = let
        # inherit (config.users.users.${config.mine.user.name}) uid;
        # inherit (config.users.groups."users") gid;
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        gid = toString config.users.groups."users".gid;
        uid = toString config.users.users.${config.mine.user.name}.uid;
      in ["${automount_opts},credentials=${config.sops.secrets.nas_auth.path},uid=${uid},gid=${gid}"];
    };
    system.stateVersion = "23.05";
  };
}
