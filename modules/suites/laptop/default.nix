{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.suites.laptop;
in {
  options.ironman.suites.laptop = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman = {
      intel-video = enabled;
      suites.workstation = enabled;
      wireless-profiles = enabled;
    };
    services.xserver.libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
  };
}
