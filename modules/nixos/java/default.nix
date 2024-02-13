{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.java;
in {
  options.mine.java = {
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
