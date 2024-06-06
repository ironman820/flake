{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  s = config.sops.secrets;
  v = config.vars;
in {
  environment.systemPackages = with nixpkgs; [
    cifs-utils
    enum4linux
    suidChroot
  ];
  fileSystems."/mnt/nas/media" = {
    device = "//192.168.254.252/Media";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      gid = l.toString config.users.groups."users".gid;
      uid = l.toString config.users.users.${v.username}.uid;
    in ["${automount_opts},credentials=${s.home_nas.path},uid=${uid},gid=${gid}"];
  };
  sops.secrets.home_nas.sopsFile = ./__secrets/personal.yml;
}
