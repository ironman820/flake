{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.firmware;
in
{
  options.ironman.firmware = {
    enable = mkBoolOpt false "Enable or disable sops support";
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    #   firmware-manager
    #   gnome-firmware
    # ];
    services.fwupd = enabled;
  };
}
