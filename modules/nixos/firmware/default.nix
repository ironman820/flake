{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.firmware;
in
{
  options.ironman.firmware = {
    enable = mkEnableOption "Enable or disable firmware support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firmware-manager
      gnome-firmware
    ];
    services.fwupd = enabled;
  };
}
