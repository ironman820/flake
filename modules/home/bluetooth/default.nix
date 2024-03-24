{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.bluetooth;
  os = osConfig.mine.bluetooth;
in {
  options.mine.home.bluetooth = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    services.blueman-applet.enable = true;
  };
}
