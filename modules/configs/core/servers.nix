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
        bazarr = {
          inherit user;
          ip = "192.168.248.120";
          service = {
            enable = true;
            port = config.services.bazarr.settings.general.port;
          };
        };
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
            port = config.services.bookorbit.environment.PORT;
          };
        };
        mymusic = {
          inherit user;
          ip = "192.168.248.126";
          publicFacing = true;
          service = {
            enable = true;
            port = config.services.navidrome.settings.Port;
          };
        };
        slsk = {
          inherit user;
          ip = "192.168.248.125";
          service = {
            enable = true;
            port = config.services.slskd.settings.web.port;
          };
        };
        spoolman = {
          inherit user;
          ip = "192.168.248.105";
          service = {
            enable = true;
            port = config.services.spoolman.port;
          };
        };
        storage = {
          inherit user;
          ip = "192.168.248.100";
          service = {
            enable = true;
            port = 3923;
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
