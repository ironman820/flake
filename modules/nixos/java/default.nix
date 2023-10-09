{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.java;
in
{
  options.ironman.java = {
    enable = mkEnableOption "Enable or disable java support";
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    #   adoptopenjdk-icedtea-web
    #   # myIcedTea
    #   # newIcedTea
    # ];
    programs.java = {
      binfmt = true;
      enable = true;
      package = pkgs.jdk17;
    };
  };
}
