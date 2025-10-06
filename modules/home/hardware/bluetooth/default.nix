{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.hardware.bluetooth;
  os = osConfig.mine.hardware.bluetooth;
in {
  options.mine.home.hardware.bluetooth = {
    enable = mkBoolOpt os.utility "Enable the module";
  };
  config = mkIf cfg.enable {
    services.blueman-applet.enable = true;
  };
}
