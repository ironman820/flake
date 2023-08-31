{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.virtual.guest;
in {
  options.ironman.virtual.guest = with types; {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    services = {
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
      spice-webdavd.enable = true;
    };
  };
}
