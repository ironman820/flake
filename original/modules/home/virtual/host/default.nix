{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.virtual.host;
  os = osConfig.mine.virtual.host;
in {
  options.mine.home.virtual.host = {
    enable = mkBoolOpt os.enable "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      virt-manager
    ];
  };
}
