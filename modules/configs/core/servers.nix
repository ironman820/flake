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
        thingport = {
          ip = "192.168.248.127";
          service.enable = true;
        };
      };
    };
}
