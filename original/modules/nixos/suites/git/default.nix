{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) str either path attrs;
  cfg = config.mine.suites.server.git;
in {
  options.mine.suites.server.git = {
    enable = mkEnableOption "Enable the default settings?";
    host = mkOpt str config.system.name "Hostname for gitlab";
    initialRootPasswordFile = mkOpt (either str path) "" "Root password";
    ipAddress = mkOpt str "" "IP address of gitlab instance";
    smtp = mkOpt attrs {} "SMTP configuration options, see mine.servers.git";
  };

  config = mkIf cfg.enable {
    mine = {
      servers.gitlab = {
        inherit (cfg) ipAddress host initialRootPasswordFile smtp;
        enable = true;
        databasePassFile = config.sops.secrets."gitlab/databasePass".path;
        secrets = {
          secretFile = config.sops.secrets."gitlab/secrets/secret".path;
          otpFile = config.sops.secrets."gitlab/secrets/otp".path;
          dbFile = config.sops.secrets."gitlab/secrets/db".path;
        };
      };
      sops.secrets = {
        "gitlab/databasePass" = {
          group = config.users.groups.keys.name;
          mode = "0440";
          sopsFile = ./secrets/gitlab.yaml;
        };
        "gitlab/secrets/secret" = {
          group = config.users.groups.keys.name;
          mode = "0440";
          sopsFile = ./secrets/gitlab.yaml;
        };
        "gitlab/secrets/otp" = {
          group = config.users.groups.keys.name;
          mode = "0440";
          sopsFile = ./secrets/gitlab.yaml;
        };
        "gitlab/secrets/db" = {
          group = config.users.groups.keys.name;
          mode = "0440";
          sopsFile = ./secrets/gitlab.yaml;
        };
      };
    };
    users.users.gitlab.extraGroups = [
      config.users.groups.keys.name
    ];
  };
}
