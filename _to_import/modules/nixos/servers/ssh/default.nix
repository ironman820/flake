{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.servers.ssh;
in {
  options.mine.servers.ssh = {
    enable = mkBoolOpt true "Enable the module";
    PasswordAuthentication = mkBoolOpt true "Enable password authentication";
  };
  config = mkIf cfg.enable {
    services = {
      openssh = enabled // {
        settings = {
          inherit (cfg) PasswordAuthentication;
        };
      };
    };
  };
}
