{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkIf types;
  inherit (lib.ironman) enabled mkBoolOpt mkOpt;
  inherit (lib.types) lines;

  cfg = config.ironman.home.nvim;
  initLua = ''
    -- [[
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require "keymaps"
    require "lazy-config"
    require "autopairs-config"
    require "bufferline-config"
    require "git-config"
    require "hop-config"
    require "indentline-config"
    require "lsp-config"
    require "lualine-config"
    require "nvim-tree-config"
    require "options"
    require "telescope-config"
    require "toggleterm-config"
    require "treesitter-config"
    require "undotree-config"
    require "whichkey"
    -- ]]
  '';
in {
  options.ironman.home.nvim = {
    enable = mkBoolOpt true "Install NeoVim";
    extraLuaConfig = mkOpt lines initLua "Extra Config";
  };

  config = mkIf cfg.enable {
    ironman.home.build-utils = enabled;
    home = {
      file = {
        ".config/nvim/lua".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/flake/modules/home/nvim/config/lua";
        ".config/nvim/lazy-lock.json".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/flake/modules/home/nvim/config/lazy-lock.json";
      };
      packages = with pkgs; [
        cargo
        python3
        unzip
        wl-clipboard
      ];
      shellAliases = {
        "nano" = "nvim";
        "nv" = "nvim";
      };
    };
    programs.neovim = {
      defaultEditor = true;
      enable = true;
      extraLuaConfig = cfg.extraLuaConfig;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };
}
