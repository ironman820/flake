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
    programs.java = {
      binfmt = true;
      enable = true;
      package = pkgs.jdk17;
    };
  };
}
