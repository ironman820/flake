{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.home.nvim;
  initLua = '''';
in {
  options.ironman.home.nvim = {
    enable = mkBoolOpt true "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      defaultEditor = true;
      enable = true;
      extraLuaConfig = initLua;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };
}
