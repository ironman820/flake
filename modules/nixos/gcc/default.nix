{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.gcc;
in
{
  options.ironman.gcc = {
    enable = mkEnableOption "Enable gcc utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      glibc
    ];
  };
}
