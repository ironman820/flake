{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.libraries.java;
in {
  options.mine.libraries.java = {
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
