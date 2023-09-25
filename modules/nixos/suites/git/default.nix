{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.suites.server.git;
in
{
  options.ironman.suites.server.git = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
    host = mkOpt str config.system.name "Hostname for gitlab";
    initialRootPasswordFile = mkOpt (either str path) "" "Root password";
    ipAddress = mkOpt str "" "IP address of gitlab instance";
    smtp = mkOpt attrs {} "SMTP configuration options, see ironman.servers.git";
  };

  config = mkIf cfg.enable {
    ironman = {
      servers.git = {
        enable = true;
        databasePassFile = config.sops.secrets."gitlab/databasePass".path;
        ipAddress = cfg.ipAddress;
        host = cfg.host;
        initialRootPasswordFile = cfg.initialRootPasswordFile;
        secrets = {
          secretFile = config.sops.secrets."gitlab/secrets/secret".path;
          otpFile = config.sops.secrets."gitlab/secrets/otp".path;
          dbFile = config.sops.secrets."gitlab/secrets/db".path;
        };
        smtp = cfg.smtp;
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
