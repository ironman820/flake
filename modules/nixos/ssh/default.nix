{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.ssh;
in {
  options.mine.ssh = {
    enable = mkBoolOpt true "Enable the module";
    PasswordAuthentication = mkEnableOption "Enable password authentication";
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
