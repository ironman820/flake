{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.home.build-utils;
in {
  options.ironman.home.build-utils = {
    enable = mkEnableOption "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc
      glibc
      gnumake
    ];
  };
}
