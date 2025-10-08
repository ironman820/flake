{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.suites.laptop;
in {
  options.mine.suites.laptop = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine = {
      suites.workstation = enabled;
    };
  };
}
