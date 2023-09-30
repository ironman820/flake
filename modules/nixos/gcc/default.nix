{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.gcc;
in
{
  options.ironman.gcc = {
    enable = mkBoolOpt false "Enable gcc utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      glibc
    ];
  };
}
