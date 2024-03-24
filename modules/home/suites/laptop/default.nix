{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.home.suites.laptop;
  os = osConfig.mine.suites.laptop;
in {
  options.mine.home.suites.laptop = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home = {
      hardware.bluetooth = enabled;
      suites.workstation = enabled;
    };
  };
}
