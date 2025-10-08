{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.tui.nvim;
in
{
  options.mine.tui.nvim = {
    enable = mkBoolOpt true "Install NeoVim";
  };

  config = mkIf cfg.enable {
    nixCats = enabled;
  };
}
