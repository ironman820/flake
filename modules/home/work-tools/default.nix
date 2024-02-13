{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.home.work-tools;
in {
  options.ironman.home.work-tools = {
    enable = mkEnableOption "Enable the Work Machine Tools";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        barrier
        dia
        # glocom
        qgis
        wireshark
        zoom-us
      ];
    };
  };
}
