{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.servers.ssh;
in {
  options.mine.servers.ssh = {
    enable = mkBoolOpt true "Enable the module";
    PasswordAuthentication = mkBoolOpt true "Enable password authentication";
  };
  config = mkIf cfg.enable {
    services = {
      openssh = {
        enable = true;
        settings = {
          inherit (cfg) PasswordAuthentication;
          PermitRootLogin = mkDefault "no";
        };
      };
    };
  };
}
