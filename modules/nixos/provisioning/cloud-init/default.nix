{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.provisioning.cloud-init;
in {
  options.mine.provisioning.cloud-init = {
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
