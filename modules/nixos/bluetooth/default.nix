{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.bluetooth;
in {
  options.mine.bluetooth = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    hardware.bluetooth = enabled;
    services.blueman = enabled;
  };
}
