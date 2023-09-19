{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.firmware;
in
{
  options.ironman.firmware = {
    enable = mkBoolOpt false "Enable or disable firmware support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firmware-manager
      gnome-firmware
    ];
    services.fwupd = enabled;
  };
}
