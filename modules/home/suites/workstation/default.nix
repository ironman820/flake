{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.home.suites.workstation;
  os = osConfig.mine.suites.workstation;
in {
  options.mine.home.suites.workstation = {
    enable = mkBoolOpt os.enable "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine.home = {
      servers.sync = enabled;
      video-tools = enabled;
      virtual.host = enabled;
    };
  };
}
