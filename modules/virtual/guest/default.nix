{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.virtual.guest;
in {
  options.ironman.virtual.guest = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    services = {
      qemuGuest = enabled;
      spice-vdagentd = enabled;
      spice-webdavd = enabled;
    };
  };
}
