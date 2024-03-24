{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.default-settings;
in {
  options.mine.home.default-settings = {
    enable = mkBoolOpt true "Enable the module";
  };
  config = mkIf cfg.enable {
    home.shellAliases."htop" = "btop";
    programs = {
      btop = {
        inherit (cfg) enable;
        settings = {
          color_theme = "catppuccin_mocha.theme";
          vim_keys = true;
        };
      };
      eza = {
        inherit (cfg) enable;
        enableAliases = true;
        extraOptions = ["--group-directories-first" "--header"];
        git = true;
        icons = true;
      };
    };
    xdg.configFile."btop/themes".source = pkgs.catppuccin-btop;
  };
}
