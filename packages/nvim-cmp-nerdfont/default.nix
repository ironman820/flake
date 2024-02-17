{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.vimUtils) buildVimPlugin;
in
  buildVimPlugin {
    name = "cmp-nerdfont";
    src = inputs.nvim-cmp-nerdfont;
  }
