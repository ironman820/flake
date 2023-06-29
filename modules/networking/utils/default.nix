{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.ironman.networking.utils;
in {
  options.ironman.networking.utils = with types; {
    enable = mkBoolOpt true "Whether to setup the nix options or not.";
  };

  config = mkIf cfg.enable {
    programs.mtr = enabled;
    environment.systemPackages = with pkgs; [
      wget
    ];
  };
}