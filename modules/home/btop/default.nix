{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.btop;
in {
  options.mine.home.btop = {
    enable = mkBoolOpt true "Enable Btop package.";
  };

  config = mkIf cfg.enable {
    home.shellAliases = { "htop" = "btop"; };
    programs.btop = {
      inherit (cfg) enable;
      settings = {
        color_theme = "catppuccin_mocha.theme";
        vim_keys = true;
      };
    };
    xdg.configFile."btop/themes".source = pkgs.catppuccin-btop;
  };
}
