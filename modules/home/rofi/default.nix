{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.rofi;
in {
  options.mine.home.rofi = { enable = mkEnableOption "Setup rofi"; };

  config = mkIf cfg.enable {
    home = { packages = with pkgs; [ nerdfonts ]; };
    programs.rofi = {
      inherit (cfg) enable;
      font = "FiraCode Nerd Font Mono";
      terminal = "${pkgs.kitty}/bin/kitty";
      theme = "${pkgs.catppuccin-rofi}/catppuccin-mocha.rasi";
    };
  };
}
