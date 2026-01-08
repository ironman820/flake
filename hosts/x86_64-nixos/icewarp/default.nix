{
  config,
  flakeRoot,
  inputs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
    self.diskoConfigurations.icewarp
  ]
  ++ (with inputs; [
    arion.nixosModules.arion
    disko.nixosModules.disko
  ])
  ++ (with self.nixosModules; [
    base
    boot-grub-clean
    git
    tmux
    virtual-docker
    x64-linux
  ]);
  home-manager = {
    users.royell = self.homeConfigurations.royell;
  };
  ironman.user = {
    name = "royell";
    email = {
      bob = "nic.eastman";
      site = "royell.org";
    };
  };
  networking = {
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "172.16.0.80";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "172.16.0.1";
      interface = "ens18";
    };
    nameservers = [
      "172.16.0.3"
      "172.16.0.4"
    ];
    useDHCP = false;
  };
  nix.settings.cores = 3;
  security.sudo.wheelNeedsPassword = false;
  services = {
    qemuGuest.enable = true;
    xserver.enable = false;
  };
  sops.secrets."icewarp.env" = {
    sopsFile = "${flakeRoot}/.secrets/icewarp.env.sops";
    format = "binary";
  };
  users.users.royell.extraGroups = [
    "networkmanager"
    "docker"
  ];
  virtualisation.arion = {
    backend = "docker";
    projects.icewarp.settings = {
      docker-compose.volumes = {
        "iwserver-cache-bash-history" = {};
        "iwserver-data" = {};
        "iwserver-mariadb" = {};
        "iwserver-redis" = {};
      };
      services = {
        icewarp.service = {
          image = "icewarptechnology/icewarp-server:latest";
          container_name = "icewarp";
          command = [
            "/usr/bin/supervisord"
            "--nodaemon"
            "-c"
            "/data/supervisord/supervisord.conf"
          ];
          depends_on = [
            "mariadb"
            "redis"
          ];
          env_file = [
            config.sops.secrets."icewarp.env".path
          ];
          ports = [
            "25:25/tcp" # SMTP
            "80:80/tcp" # HTTP
            "110:110/tcp" # POP3
            "143:143/tcp" # IMAP
            "443:443/tcp" # HTTPS
            "465:465/tcp" # SMTPS
            "587:587/tcp" # SMTP
            "993:993/tcp" # IMAPS
            "995:995/tcp" # POP3S
            "1080:1080/tcp" # SOCKS
            "5060:5060/udp" # SIP
            "5060:5060/tcp" # SIP
            "5061:5061/udp" # SIP
            "5222:5222/tcp" # XMLL
            "5223:5223/tcp" # XMPP TLS
            "5269:5269/tcp" # Groupware
          ];
          restart = "unless-stopped";
          volumes = [
            "iwserver-data:/data"
            "iwserver-cache-bash-history:/commandhistory"
          ];
        };
        laforge.service = {
          image = "icewarptechnology/laforge:2.0.3";
          environment = {
            "LAFORGE_SERVER_HTTP_LISTEN" = 25791;
          };
          ports = [
            "25791:25791"
          ];
        };
        mariadb.service = {
          image = "docker.io/library/mariadb:10.6";
          env_file = [
            config.sops.secrets."icewarp.env".path
          ];
          volumes = [
            "iwserver-mariadb:/var/lib/mysql"
          ];
        };
        redis.service = {
          image = "docker.io/library/redis:6";
          command = [
            "--appendonly"
            "yes"
          ];
          volumes = [
            "iwserver-redis:/data"
          ];
        };
      };
    };
  };
}
