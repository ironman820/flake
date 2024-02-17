{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.vimUtils) buildVimPlugin;
in
  buildVimPlugin {
    name = "transparent-nvim";
    src = inputs.transparent-nvim;
  }
