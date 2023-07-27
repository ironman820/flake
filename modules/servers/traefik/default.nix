{ config, inputs, lib, options, pkgs, system, ... }:
with lib;
let
  cfg = config.ironman.servers.traefik;
in
{
  options.ironman.servers.traefik = with types; {
    config = mkOpt attrs { } "Dynamic Config Options";
    enable = mkBoolOpt false "Enable or disable tftp support";
    static = mkOpt attrs { } "Static Config Options";
  };

  config = mkIf cfg.enable {
    ironman = {
      root-sops.secrets = {
        cloudflare_email = {
          format = "binary";
          owner = config.users.users.traefik.name;
          sopsFile = ./secrets/env.sops;
        };
      };
      servers.traefik = {
        config = {
          http = {
            middlewares = {
              default-headers.headers = {
                frameDeny = true;
                browserXssFilter = true;
                contentTypeNosniff = true;
                forceSTSHeader = true;
                stsIncludeSubdomains = true;
                stsPreload = true;
                stsSeconds = 15552000;
                customFrameOptionsValue = "SAMEORIGIN";
                customRequestHeaders.X-Forwarded-Proto = "https";
              };
              private-whitelist.ipWhiteList.sourceRange = [
                "192.168.0.0/16"
                "172.16.0.0/12"
              ];
              secured.chain.middlewares = [
                "private-whitelist"
                "default-headers"
              ];
              sslheader.headers.customrequestheaders.X-Forwarded-Proto = "https";
              traefik-auth.basicauth.users = "ironman:$$apr1$$Z7GHKYem$$/i9jllK7/e0cblgn3ofkQ/";
              traefik-secured.chain.middlewares = [
                "traefik-auth"
                "secured"
              ];
            };
            routers.traefik-secure = {
              entryPoints = "https";
              middlewares = "traefik-secured";
              rule = "Host(`proxy.desk.niceastman.com`)";
              service = "api@internal";
              tls = {
                certresolver = "cloudflare";
                domains = [
                  {
                    sans = "*.desk.niceastman.com";
                  }
                ];
              };
            };
          };
        };
        static = {
          api.dashboard = true;
          certificatesResolvers.cloudflare.acme = {
            dnsChallenge = {
              provider = "cloudflare";
              resolvers = [
                "1.1.1.1:53"
                "1.0.0.1:53"
              ];
            };
            # email = "$(cat ${config.sops.secrets.cloudflare_email.path})";
            storage = "${config.services.traefik.dataDir}/acme.json";
          };
          entrypoints = {
            http = {
              address = ":80";
              forwardedHeaders.trustedIPs = [
                "10.0.0.0/8"
                "127.0.0.1/32"
                "172.16.0.0/12"
                "192.168.0.0/16"
              ];
              http.redirections.entryPoint = {
                to = "https";
                scheme = "https";
              };
            };
            https = {
              address = ":443";
              forwardedHeaders.trustedIPs = [
                "10.0.0.0/8"
                "127.0.0.1/32"
                "172.16.0.0/12"
                "192.168.0.0/16"
              ];
            };
          };
          global.sendAnonymousUsage = false;
          serversTransport.insecureSkipVerify = true;
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    services.traefik = {
      dynamicConfigOptions = mkAliasDefinitions options.ironman.servers.traefik.config;
      enable = true;
      staticConfigOptions = mkAliasDefinitions options.ironman.servers.traefik.static;
    };
    systemd.services.traefik.serviceConfig.EnvironmentFile = config.sops.secrets.cloudflare_email.path;
  };
}
