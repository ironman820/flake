{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.home.nvim;
in {
  options.ironman.home.nvim = {
    enable = mkBoolOpt true "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
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
}
