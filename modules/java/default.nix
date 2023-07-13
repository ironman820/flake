{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.java;
in {
  options.ironman.java = {
    enable = mkBoolOpt false "Enable or disable sops support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      adoptopenjdk-icedtea-web
      # myIcedTea
      # newIcedTea
    ];
    programs.java = {
      binfmt = true;
      enable = true;
      package = pkgs.oraclejdk8;
      # package = pkgs.zulu8;
    };
  };
}
