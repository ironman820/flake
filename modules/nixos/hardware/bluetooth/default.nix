{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.hardware.bluetooth;
in {
  options.mine.hardware.bluetooth = {
    enable = mkEnableOption "Enable the module";
    utility = mkEnableOption "Install a control utility";
  };
  config = mkIf cfg.enable {
    hardware.bluetooth = enabled;
    services.blueman = {
      enable = cfg.utility;
    };
  };
}
