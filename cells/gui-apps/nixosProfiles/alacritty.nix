{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.gui-apps.alacritty;
in {
  options.mine.gui-apps.alacritty = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alacritty
      nerdfonts
    ];
  };
}
