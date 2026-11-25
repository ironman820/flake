{
  cfg,
  config,
  lib,
  name,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types)
    bool
    int
    str
    submodule
    ;
in
{
  options = {
    hostName = mkOption {
      default = name;
      description = "Host name of the server";
      type = str;
    };
    ip = mkOption {
      description = "The server's IP address";
      type = str;
    };
    publicFacing = mkEnableOption "This server hosts an internet accessible service";
    service = mkOption {
      description = "Service information";
      type = submodule {
        options = {
          enable = mkEnableOption "Enable traefik service declaration";
          name = mkOption {
            default =
              config.hostName
              + (if !config.publicFacing then (if config.workServer then ".work" else ".home") else "");
            description = "The service name";
            type = str;
          };
          port = mkOption {
            default = 8080;
            description = "Port number exposed by the service";
            type = int;
          };
        };
      };
    };
    sshEnable = mkOption {
      default = true;
      description = "Enable SSH Config for this server";
      type = bool;
    };
    user = mkOption {
      default = cfg.user.name;
      description = "Username for ssh";
      type = str;
    };
    workServer = mkEnableOption "This server is deployed on the work cluster";
  };
}
