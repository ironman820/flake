{
  flake.nixosModules.servers =
    { config, lib, ... }:
    let
      inherit (lib) mkOption;
      inherit (lib.types)
        attrsOf
        submodule
        ;
      cfg = config.ironman;
      user = "ironman";
    in
    {
      options.ironman.servers = mkOption {
        description = "Server information including static IPs, domain names, etc. centrally referenced to aid in quickly bootstrapping SSH configurations, Traefik deployments, and server config";
        type = attrsOf (
          submodule (
            { config, name, ... }:
            import ./_serverModule.nix {
              inherit
                cfg
                config
                lib
                name
                ;
            }
          )
        );
      };
      config.ironman.servers = {
        musicsync = {
          inherit user;
          ip = "192.168.248.128";
        };
        mybooks = {
          inherit user;
          ip = "192.168.248.101";
          publicFacing = true;
          service = {
            enable = true;
            port = 3000;
          };
        };
        mymusic = {
          inherit user;
          ip = "192.168.248.126";
          publicFacing = true;
          service = {
            enable = true;
            port = 4533;
          };
        };
        storage = {
          inherit user;
          ip = "192.168.248.100";
          service = {
            enable = true;
            port = 8384;
          };
        };
        thingport = {
          inherit user;
          ip = "192.168.248.127";
          service.enable = true;
        };
      };
    };
}
