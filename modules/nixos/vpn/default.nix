{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.vpn;
in
{
  options.ironman.vpn = with types; {
    enable = mkBoolOpt false "Enable or disable extra networking support";
  };

  config = mkIf cfg.enable {
    # Might be needed for OpenVPN
    boot.kernelModules = [ "tun" ];
  };
}
