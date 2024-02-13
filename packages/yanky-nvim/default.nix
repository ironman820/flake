{ inputs, pkgs, ... }:
let
  inherit (pkgs.vimUtils) buildVimPlugin;
in buildVimPlugin {
  name = "yanky-nvim";
  src = inputs.yanky-nvim;
}
