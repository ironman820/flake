{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  f = config.networking.firewall;
  l = nixpkgs.lib // mine.lib // builtins;
  s = config.sops.secrets;
in {
  services = {
    nginx = {
      enable = true;
      virtualHosts."rcm.desk.niceastman.com" = {
        default = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
        ];
        locations = {
          "/".extraConfig = ''
            index index.html index.php;
          '';
          "~ .php$".extraConfig = ''
            fastcgi_pass  unix:${config.services.phpfpm.pools.rcm.socket};
            fastcgi_index index.php;
          '';
        };
        onlySSL = true;
        root = "/data/rcm";
        sslCertificate = s.rcm_cert.path;
        sslCertificateKey = s.rcm_key.path;
      };
    };
    php = {
      enable = true;
      ini = [
        "display_errors = On"
        "error_reporting = E_ALL"
        "max_execution_time = 120"
        "max_input_time = 60"
        "memory_limit = 768M"
        "post_max_size = 50M"
        "register_global = On"
        "short_open_tag = Off"
      ];
    };
  };
  environment = {
    systemPackages = (with pkgs; [sonar-scanner-cli]) ++ (with pkgs.php74Packages; [phpcbf php-cs-fixer]);
    unixODBCDrivers = with pkgs.unixODBCDrivers; [msodbcsql17];
  };
  networking.firewall =
    l.mkIf f.enable {allowedTCPPorts = [443];};
  sops.secrets = {
    rcm_cert = {
      format = "binary";
      mode = "0400";
      owner = config.users.users.nginx.name;
      sopsFile = ./__secrets/cert.pem;
    };
    rcm_key = {
      format = "binary";
      mode = "0400";
      owner = config.users.users.nginx.name;
      sopsFile = ./__secrets/key.pem;
    };
  };
  users.users.nginx.home = "/home/${config.users.users.nginx.name}";
}
