{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.gcc;
in
{
  options.ironman.gcc = {
    enable = mkBoolOpt true "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      glibc
    ];
  };
}
