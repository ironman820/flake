{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = v.gitlab;
  f = config.networking.firewall;
  l = nixpkgs.lib // mine.lib // builtins;
  t = l.types;
  v = config.vars;
in {
  options.vars.gitlab = {
    databasePassFile =
      l.mkOpt (t.either t.str t.path) "" "File with the database password";
    ipAddress = l.mkOpt t.str "" "IP address for gitlab instance";
    host = l.mkOpt t.str config.system.name "Hostname for gitlab instance";
    initialRootPasswordFile =
      l.mkOpt (t.either t.str t.path) "" "file with the initial root password";
    secrets = {
      secretFile = l.mkOpt (t.either t.str t.path) "" "file with the gitlab secret";
      otpFile = l.mkOpt (t.either t.str t.path) "" "Secret storage file";
      dbFile = l.mkOpt (t.either t.str t.path) "" "secret storage file";
    };
    smtp = {
      address = l.mkOpt t.str "" "SMTP sever address";
      authentication = l.mkOpt t.str "" "Authentication type";
      domain = l.mkOpt t.str "" "Email domain name";
      enable = l.mkBoolOpt false "Enable GitLab email settings";
      passwordFile = t.mkOpt (t.either t.str t.path) "" "File with password for email";
      username = l.mkOpt t.str "" "Username for email";
    };
  };

  config = {
    networking.firewall = l.mkIf f.enable {
      allowedTCPPorts = [22 80 443];
    };
    services = {
      caddy = {
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
          "${c.ipAddress}" = passLoc;
          "${c.host}" = passLoc;
        };
      };
      gitlab = {
        inherit (c) host initialRootPasswordFile;
        databasePasswordFile = c.databasePassFile;
        https = true;
        initialRootEmail = v.email;
        port = 443;
        secrets = {
          inherit (c.secrets) secretFile otpFile dbFile;
          jwsFile =
            pkgs.runCommand "oidcKeyBase" {}
            "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
        };
        smtp = l.mkIf c.smtp.enable {
          inherit
            (c.smtp)
            address
            authentication
            domain
            enable
            passwordFile
            username
            ;
        };
      };
      openssh = l.enabled;
    };
    systemd.services.gitlab-backup.environment.BACKUP = "dump";
  };
}
