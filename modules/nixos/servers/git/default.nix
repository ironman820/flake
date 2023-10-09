{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled mkBoolOpt mkOpt;
  inherit (lib.types) either str path;
  cfg = config.ironman.servers.git;
in
{
  options.ironman.servers.git = {
    enable = mkEnableOption "Enable or disable gitlab";
    databasePassFile = mkOpt (either str path) "" "File with the database password";
    ipAddress = mkOpt str "" "IP address for gitlab instance";
    host = mkOpt str config.system.name "Hostname for gitlab instance";
    initialRootPasswordFile = mkOpt (either str path) "" "file with the initial root password";
    secrets = {
      secretFile = mkOpt (either str path) "" "file with the gitlab secret";
      otpFile = mkOpt (either str path) "" "Secret storage file";
      dbFile = mkOpt (either str path) "" "secret storage file";
    };
    smtp = {
      address = mkOpt str "" "SMTP sever address";
      authentication = mkOpt str "" "Authentication type";
      domain = mkOpt str "" "Email domain name";
      enable = mkBoolOpt false "Enable GitLab email settings";
      passwordFile = mkOpt (either str path) "" "File with password for email";
      username = mkOpt str "" "Username for email";
    };
  };

  config = mkIf cfg.enable {
    ironman.servers.caddy = {
      enable = true;
      virtualHosts = let
        passLoc = {
          extraConfig = ''
            reverse_proxy unix//run/gitlab/gitlab-workhorse.socket {
              header_up X-Forwarded-Proto https
              header_up X-Forwarded-Ssl on
            }
          '';
        };
      in {
        "${cfg.ipAddress}" = passLoc;
        "${cfg.host}" = passLoc;
      };
    };
    networking.firewall.allowedTCPPorts = [
      22
      80
      443
    ];
    services = {
      gitlab = {
        enable = true;
        databasePasswordFile = cfg.databasePassFile;
        host = cfg.host;
        https = true;
        initialRootEmail = config.ironman.user.email;
        initialRootPasswordFile = cfg.initialRootPasswordFile;
        port = 443;
        secrets = {
          secretFile = cfg.secrets.secretFile;
          otpFile = cfg.secrets.otpFile;
          dbFile = cfg.secrets.dbFile;
          jwsFile = pkgs.runCommand "oidcKeyBase" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
        };
        smtp = mkIf cfg.smtp.enable {
          address = cfg.smtp.address;
          authentication = cfg.smtp.authentication;
          domain = cfg.smtp.domain;
          enable = true;
          passwordFile = cfg.smtp.passwordFile;
          username = cfg.smtp.username;
        };
      };
      openssh = enabled;
    };
    systemd.services.gitlab-backup.environment.BACKUP = "dump";
  };
}
