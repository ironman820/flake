{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.cloudInit;
in {
  options.mine.cloudInit = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    services.cloud-init = {
      inherit (cfg) enable;
      btrfs = enabled;
      network = enabled;
    };
  };
}
