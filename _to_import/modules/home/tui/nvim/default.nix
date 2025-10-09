{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) lines;

  cfg = config.mine.home.tui.nvim;
  initLua = ''
    require("startup")
  '';
  os = osConfig.mine.tui.nvim;
in {
  options.mine.home.tui.nvim = {
    enable = mkBoolOpt os.enable "Install NeoVim";
    extraLuaConfig = mkOpt lines initLua "Extra Config";
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
      };
      shellAliases = {
        "nano" = "nvim";
        "nv" = "nvim";
      };
    };
  };
}
