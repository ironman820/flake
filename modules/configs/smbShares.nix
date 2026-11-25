{
  flake.nixosModules.smbShares =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mapAttrs mkOption;
      inherit (lib.types)
        attrsOf
        int
        path
        str
        submodule
        ;
      cfg = config.ironman.smbShares;
    in
    {
      options.ironman.smbShares = {
        fs = mkOption {
          description = "File systems information";
          type = attrsOf (
            submodule (
              { name, ... }: {
                options = {
                  server = mkOption {
                    description = "URL/IP of the remote server";
                    type = str;
                  };
                  sharePath = mkOption {
                    default = name;
                    description = "Path on remote system to mount";
                    type = path;
                  };
                };
              }
            )
          );
        };
        gid = mkOption {
          default = 1000;
          description = "Group ID used to mount shares";
          type = int;
        };
        uid = mkOption {
          default = 1000;
          description = "User ID used to mount shares";
          type = int;
        };
      };
      config = {
        environment.systemPackages = [
          pkgs.cifs-utils
        ];
        fileSystems = mapAttrs (name: value: {
          device = "//${value.server}${value.sharePath}";
          fsType = "cifs";
          options =
            let
              automount_opts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
            in
            [
              "${automount_opts},uid=${toString cfg.uid},gid=${toString cfg.gid}"
            ];
        }) cfg.fs;
      };
    };
}
