{
  config,
  pkgs,
  ...
}: let
  inherit (builtins) toString;
in {
  mine = {
    sops.secrets = {
      home-nas = {
        sopsFile = ./secrets/personal.yml;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    cifs-utils
    enum4linux
    suidChroot
  ];
  fileSystems."/mnt/nas/media" = {
    device = "//192.168.254.252/Media";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      gid = toString config.users.groups."users".gid;
      uid = toString config.users.users.${config.mine.user.name}.uid;
    in ["${automount_opts},credentials=${config.sops.secrets.home-nas.path},uid=${uid},gid=${gid}"];
  };
}
