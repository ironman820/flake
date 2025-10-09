{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.build-utils;
in {
  options.mine.home.build-utils = {
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
