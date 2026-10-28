{
  self,
  ...
}:
{
  flake.nixosModules.sonarqube =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        mkEnableOption
        mkForce
        mkIf
        mkOption
        mkOverride
        types
        ;
      cfg = config.ironman;
      sqb = cfg.sonarqube;
    in
    {
      options.ironman.sonarqube = {
        enable = mkEnableOption "Enable SonarQube runtime";
        ip = mkOption {
          default = "";
          description = "Droppedneedle IP";
          type = types.str;
        };
      };
      config = {
        services = {
          postgresql = mkIf sqb.enable {
            enable = true;
            authentication = ''
              host sonarqube sonarqube 172.16.0.0/12 password
            '';
            ensureDatabases = [
              "sonarqube"
            ];
            ensureUsers = [
              {
                ensureDBOwnership = true;
                name = "sonarqube";
              }
            ];
            settings.listen_addresses = mkForce "*";
          };
          traefik.dynamicConfigOptions.http = {
            routers.sonarqube = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`sonarqube.home.niceastman.com`)";
              service = "sonarqube";
              tls = { };
            };
            services.sonarqube.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://${sqb.ip}:9000";
                }
              ];
              serversTransport = "insecure";
            };
          };
        };
        sops.secrets."sonarqube.env" = mkIf sqb.enable {
          sopsFile = "${self.outPath}/.secrets/sonarqube.yaml";
          group = "docker";
          owner = config.ironman.user.name;
          mode = "0440";
        };
        systemd = mkIf sqb.enable {
          services = {
            docker = {
              serviceConfig = {
                LimitNOFILE = 131072;
                LimitNPROC = 8192;
              };
            };
            "docker-sonarqube" = {
              serviceConfig = {
                Restart = mkOverride 90 "always";
                RestartMaxDelaySec = mkOverride 90 "1m";
                RestartSec = mkOverride 90 "100ms";
                RestartSteps = mkOverride 90 9;
              };
              after = [
                "docker-network-sonarqube_default.service"
                "docker-volume-sonarqube_data.service"
                "docker-volume-sonarqube_extensions.service"
                "docker-volume-sonarqube_logs.service"
              ];
              requires = [
                "docker-network-sonarqube_default.service"
                "docker-volume-sonarqube_data.service"
                "docker-volume-sonarqube_extensions.service"
                "docker-volume-sonarqube_logs.service"
              ];
              partOf = [
                "docker-compose-sonarqube-root.target"
              ];
              wantedBy = [
                "docker-compose-sonarqube-root.target"
              ];
            };
            # Network
            "docker-network-sonarqube_default" = {
              path = [ pkgs.docker ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStop = "docker network rm -f sonarqube_default";
              };
              script = ''
                docker network inspect sonarqube_default || docker network create sonarqube_default
              '';
              partOf = [ "docker-compose-sonarqube-root.target" ];
              wantedBy = [ "docker-compose-sonarqube-root.target" ];
            };
            # Volumes
            "docker-volume-sonarqube_data" = {
              path = [ pkgs.docker ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
              script = ''
                docker volume inspect sonarqube_data || docker volume create sonarqube_data
              '';
              partOf = [ "docker-compose-sonarqube-root.target" ];
              wantedBy = [ "docker-compose-sonarqube-root.target" ];
            };
            "docker-volume-sonarqube_extensions" = {
              path = [ pkgs.docker ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
              script = ''
                docker volume inspect sonarqube_extensions || docker volume create sonarqube_extensions
              '';
              partOf = [ "docker-compose-sonarqube-root.target" ];
              wantedBy = [ "docker-compose-sonarqube-root.target" ];
            };
            "docker-volume-sonarqube_logs" = {
              path = [ pkgs.docker ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
              script = ''
                docker volume inspect sonarqube_logs || docker volume create sonarqube_logs
              '';
              partOf = [ "docker-compose-sonarqube-root.target" ];
              wantedBy = [ "docker-compose-sonarqube-root.target" ];
            };
          };
          targets."docker-compose-sonarqube-root" = {
            unitConfig = {
              Description = "Root target generated by compose2nix.";
            };
            wantedBy = [ "multi-user.target" ];
          };
        };
        virtualisation.oci-containers = mkIf sqb.enable {
          backend = "docker";
          containers = {
            sonarqube = {
              environment = {
                SONAR_JDBC_URL = "jdbc:postgresql://192.168.248.107/sonarqube";
              };
              environmentFiles = [
                config.sops.secrets."sonarqube.env".path
              ];
              image = "sonarqube:community";
              hostname = "sonarqube";
              ports = [
                "9000:9000"
              ];
              volumes = [
                "sonarqube_data:/opt/sonarqube/data"
                "sonarqube_extensions:/opt/sonarqube/extensions"
                "sonarqube_logs:/opt/sonarqube/logs"
              ];
              log-driver = "journald";
              extraOptions = [
                "--network-alias=sonarqube"
                "--network=sonarqube_default"
              ];
            };
          };
        };
      };
    };
}
