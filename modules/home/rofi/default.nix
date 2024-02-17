{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine.home.user.settings) terminal;
  inherit (lib) mkDefault mkEnableOption mkIf;

  cfg = config.mine.home.rofi;
in {
  options.mine.home.rofi = {enable = mkEnableOption "Setup rofi";};

  config = mkIf cfg.enable {
    home = {packages = with pkgs; [nerdfonts];};
    programs.rofi = {
      inherit (cfg) enable;
      font = mkDefault "FiraCode Nerd Font Mono";
      terminal = "${pkgs.${terminal}}/bin/${terminal}";
      theme = mkDefault "${pkgs.catppuccin-rofi}/catppuccin-mocha.rasi";
    };
  };
}
