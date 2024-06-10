{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.hardware.bluetooth;
  imp = config.mine.impermanence.enable;
in {
  options.mine.hardware.bluetooth = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.persistence."/persist/root".directories = mkIf imp [
      "/var/lib/bluetooth"
    ];
    hardware.bluetooth = enabled;
    services.blueman = enabled;
  };
}
