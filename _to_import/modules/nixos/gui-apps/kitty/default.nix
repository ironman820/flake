{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.gui-apps.kitty;
in {
  options.mine.gui-apps.kitty = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      catppuccin-kitty
      kitty
    ];
  };
}
