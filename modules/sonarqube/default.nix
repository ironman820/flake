{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOverride;
  inherit (lib.mine) enabled;

  cfg = config.mine.servers.sonarqube;
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
  options.mine.servers.sonarqube = {
    enable = mkEnableOption "Enable Sonarqube";
  };

  config = mkIf cfg.enable {
    mine = {
      servers.postgresql = {
        authentication = mkOverride 30 ''
          local all sonarqube peer
        '';
        # ${config.mine.networking.network}/${config.mine.networking.prefix} all sonarqube peer
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
    environment.systemPackages = [
      update-containers
    ];
    networking.firewall = mkIf config.mine.networking.firewall {allowedTCPPorts = [9000];};
    virtualisation.oci-containers = {
      backend = "docker";
      containers.sonarqube = {
        autoStart = true;
        environment = {
          SONAR_JDBC_URL = "jdbc:postgresql://localhost:5432/sonarqube";
          SONAR_JDBC_USERNAME = "sonarqube";
          SONAR_JDBC_PASSWORD = "sonarqube";
        };
        extraOptions = ["--network=host"];
        image = "sonarqube:community";
        ports = ["9000:9000"];
        # user = "${config.mine.user.name}:${config.users.users.${config.mine.user.name}.group}";
        volumes = [
          "sonarqube_data:/opt/sonarqube/data"
          "sonarqube_logs:/opt/sonarqube/logs"
          "sonarqube_extensions:/opt/sonarqube/extensions"
        ];
      };
    };
  };
}
