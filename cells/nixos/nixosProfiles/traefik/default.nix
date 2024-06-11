{
  cell,
  config,
  inputs,
}: let
  s = config.sops.secrets;
in {
  networking.firewall.allowedTCPPorts = [80 443];
  services.traefik = {
    dynamicConfigOptions = {
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
          private-whitelist.ipWhiteList.sourceRange = ["192.168.0.0/16" "172.16.0.0/12"];
          secured.chain.middlewares = ["private-whitelist" "default-headers"];
          sslheader.headers.customrequestheaders.X-Forwarded-Proto = "https";
        };
        routers.traefik-secure = {
          entryPoints = "https";
          middlewares = "secured";
          rule = "Host(`proxy.desk.niceastman.com`)";
          service = "api@internal";
          tls = {
            certresolver = "cloudflare";
            domains = [{sans = "*.desk.niceastman.com";}];
          };
        };
      };
    };
    enable = true;
    staticConfigOptions = {
      api.dashboard = true;
      certificatesResolvers.cloudflare.acme = {
        dnsChallenge = {
          provider = "cloudflare";
          resolvers = ["1.1.1.1:53" "1.0.0.1:53"];
        };
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
  sops.secrets.cloudflare_email = {
    format = "binary";
    owner = config.users.users.traefik.name;
    sopsFile = ./__secrets/env.sops;
  };
  systemd.services.traefik.serviceConfig.EnvironmentFile = [s.cloudflare_email.path];
}
