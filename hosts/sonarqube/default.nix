{
  config,
  flakeRoot,
  lib,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    proxmox
    docker
    x64-linux
  ]);
  boot.kernel.sysctl = {
    "vm.max_map_count" = 524288;
    "fs.file-max" = 131072;
  };
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  networking.firewall.allowedTCPPorts = [
    5432
    9000
  ];
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh.settings.PermitRootLogin = "no";
    postgresql = {
      enable = true;
      authentication = ''
        host sonarqube sonarqube 172.17.0.0/16 password
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
      settings.listen_addresses = lib.mkForce "*";
    };
    qemuGuest.enable = true;
  };
  sops.secrets."sonarqube.env" = {
    sopsFile = "${flakeRoot}/.secrets/sonarqube.yaml";
    group = "docker";
    owner = config.ironman.user.name;
    mode = "0440";
  };
  systemd.services.docker.serviceConfig = {
    LimitNOFILE = 131072;
    LimitNPROC = 8192;
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      sonarqube = {
        autoRemoveOnStop = false;
        autoStart = true;
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
      };
    };
  };
}
