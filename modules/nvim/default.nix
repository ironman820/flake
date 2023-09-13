{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.nvim;
in {
  options.ironman.nvim = {
    enable = mkBoolOpt true "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    ironman = {
      gcc = enabled;
      home.extraOptions = {
        programs.neovim = {
          defaultEditor = true;
          enable = true;
          plugins = with pkgs.vimPlugins; [
            nvchad
            vim-tmux-navigator
          ];
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
        };
        xdg.configFile."nvim" = {
          # mode = "0600";
          recursive = true;
          source = "${pkgs.vimPlugins.nvchad}";
        };
      };
    };
  };
}
