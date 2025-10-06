{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.work-tools;
in {
  options.mine.home.work-tools = {
    enable = mkEnableOption "Enable the Work Machine Tools";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # barrier
        dia
        qgis
        wireshark
        zoom-us
      ];
    };
  };
}
