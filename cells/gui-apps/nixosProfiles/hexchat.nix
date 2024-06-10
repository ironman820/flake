{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.gui-apps.hexchat;
in {
  options.mine.gui-apps.hexchat = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hexchat
    ];
  };
}
