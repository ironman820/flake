{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.virtual.guest;
in {
  options.mine.virtual.guest = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    services = {
      qemuGuest = enabled;
      spice-vdagentd = enabled;
      spice-webdavd = enabled;
    };
  };
}
