{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkIf types;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) lines;

  cfg = config.ironman.home.build-utils;
in {
  options.ironman.home.build-utils = {
    enable = mkBoolOpt false "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [
      gnumake
    ];
  };
}
