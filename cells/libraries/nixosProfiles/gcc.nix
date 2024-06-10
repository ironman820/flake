{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.libraries.gcc;
in {
  options.mine.libraries.gcc = {
    enable = mkEnableOption "Enable gcc utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      glibc
      gnumake
    ];
  };
}
