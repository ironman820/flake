{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOverride;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.servers.sonarqube;
  update-containers = pkgs.writeShellScriptBin "update-containers" ''
    SUDO=""
    if [[ $(id -u) -ne 0 ]]; then
      SUDO="sudo"
    fi

      images=$($SUDO ${pkgs.docker}/bin/docker ps -a --format="{{.Image}}" | sort -u)

      for image in $images
      do
        $SUDO ${pkgs.docker}/bin/docker pull $image
      done
  '';
in {
  options.ironman.servers.sonarqube = {
    enable = mkEnableOption "Enable Sonarqube";
  };

  config = mkIf cfg.enable {
    ironman = {
      servers.postgresql = {
        authentication = mkOverride 30 ''
          local all sonarqube peer
        '';
        # ${config.ironman.networking.network}/${config.ironman.networking.prefix} all sonarqube peer
        enable = true;
        script = [''
          CREATE ROLE sonarqube WITH PASSWORD 'sonarqube' CREATEDB LOGIN;
          CREATE DATABASE sonarqube;
          GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;
        ''];
      };
      virtual.docker = enabled;
    };
    environment.systemPackages = [
      update-containers
    ];
    networking.firewall = mkIf config.ironman.networking.firewall { allowedTCPPorts = [ 9000 ]; };
    virtualisation.oci-containers = {
      backend = "docker";
      containers.sonarqube = {
        autoStart = true;
        environment = {
          SONAR_JDBC_URL = "jdbc:postgresql://localhost:5432/sonarqube";
          SONAR_JDBC_USERNAME = "sonarqube";
          SONAR_JDBC_PASSWORD = "sonarqube";
        };
        extraOptions = [ "--network=host" ];
        image = "sonarqube:community";
        ports = [ "9000:9000" ];
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
