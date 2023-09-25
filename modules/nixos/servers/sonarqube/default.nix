{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.sonarqube;
in
{
  options.ironman.servers.sonarqube = with types; {
    enable = mkBoolOpt false "Enable Sonarqube";
  };

  config = mkIf cfg.enable {
    ironman = {
      servers.postgresql = {
        authentication = mkOverride 30 ''
          local all sonarqube peer
        '';
          # ${config.ironman.networking.network}/${config.ironman.networking.prefix} all sonarqube peer
        enable = true;
        script = [
          ''
            CREATE ROLE sonarqube WITH PASSWORD 'sonarqube' CREATEDB LOGIN;
            CREATE DATABASE sonarqube;
            GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;
          ''
        ];
      };
      virtual.docker = enabled;
    };
    networking.firewall.allowedTCPPorts = [
      9000
    ];
    virtualisation.oci-containers = {
      backend = "docker";
      containers.sonarqube = {
        autoStart = true;
        environment = {
          SONAR_JDBC_URL = "jdbc:postgresql://localhost:5432/sonarqube";
          SONAR_JDBC_USERNAME = "sonarqube";
          SONAR_JDBC_PASSWORD = "sonarqube";
        };
        extraOptions = [
          "--network=host"
        ];
        image = "sonarqube:community";
        ports = [
          "9000:9000"
        ];
        # user = "${config.ironman.user.name}:${config.users.users.${config.ironman.user.name}.group}";
        volumes = [
          "sonarqube_data:/opt/sonarqube/data"
          "sonarqube_logs:/opt/sonarqube/logs"
          "sonarqube_extensions:/opt/sonarqube/extensions"
        ];
      };
    };
  };
}
