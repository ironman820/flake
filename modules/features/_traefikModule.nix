{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) bool str;
in
{
  mkTraefikOptions =
    {
      service ? "fizzbuzz",
      domain ? "fizzbuzz.home",
      port ? "8080",
      private ? true,
    }:
    {
      enable = mkEnableOption "Enable the ${service} server";
      domain = mkOption {
        default = domain;
        description = "Domain to access ${service} from";
        type = str;
      };
      ip = mkOption {
        default = "";
        description = "${service} IP";
        type = str;
      };
      port = mkOption {
        default = port;
        description = "Web port that ${service} is accessible from.";
        type = str;
      };
      private = mkOption {
        default = private;
        description = "Is the service only available on the local network?";
        type = bool;
      };
    };
  mkTraefikConfig = { cfg, name }: {
    routers.${name} = {
      entryPoints = "https";
      middlewares = if cfg.private then "secured" else "default-headers";
      rule = "Host(`${cfg.domain}.niceastman.com`)";
      service = name;
      tls = { };
    };
    services.${name}.loadBalancer = {
      passHostHeader = true;
      servers = [
        {
          url = "http://${cfg.ip}:${cfg.port}";
        }
      ];
      serversTransport = "insecure";
    };
  };
}
