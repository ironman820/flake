{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.vimUtils) buildVimPlugin;
in
  buildVimPlugin {
    name = "cellular-automaton";
    src = inputs.cellular-automaton-nvim;
  }
