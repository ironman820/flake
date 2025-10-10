{
  config,
  ...
}:
{
  flake.nixosModules."hosts/friday" = {
    imports = with config.flake.nixosModules; [
      apps-gui
      base
      config.flake.diskoConfigurations.friday
      drive-shares-personal
      x64-linux
    ];
    # TODO: replace with the correct scan from friday
    facter.reportPath = ./facter.json;
    # let
    #   # inherit (builtins) toString;
    #   inherit (lib.mine) enabled;
    # in
    # {
    # mine = {
    #   networking.profiles.work = true;
    #   sops.secrets.nas_auth.sopsFile = ./secrets/secrets.yml;
    #   suites.laptop = enabled;
    # };
    # fileSystems."/mnt/nas" = {
    #   device = "//192.168.254.252/Media";
    #   fsType = "cifs";
    #   options =
    #     let
    #       # inherit (config.users.users.${config.mine.user.name}) uid;
    #       # inherit (config.users.groups."users") gid;
    #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    #       gid = toString config.users.groups."users".gid;
    #       uid = toString config.users.users.${config.mine.user.name}.uid;
    #     in
    #     [ "${automount_opts},credentials=${config.sops.secrets.nas_auth.path},uid=${uid},gid=${gid}" ];
    # };
    # };
  };
}
