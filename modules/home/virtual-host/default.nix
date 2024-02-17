{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.virtual-host;
in {
  options.mine.home.virtual-host = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      virt-manager
    ];
  };
}
