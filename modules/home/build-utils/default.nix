{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt;

  cfg = config.ironman.home.build-utils;
in {
  options.ironman.home.build-utils = {
    enable = mkBoolOpt false "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc
      glibc
      gnumake
    ];
  };
}
