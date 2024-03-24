{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.hardware.bluetooth;
  imp = config.mine.home.impermanence.enable;
  os = osConfig.mine.hardware.bluetooth;
in {
  options.mine.home.hardware.bluetooth = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home.tui.just.rootPersist = mkIf imp [
      "mkdir -p /persist/root/var/lib/bluetooth"
    ];
    services.blueman-applet.enable = true;
  };
}
