{ inputs, pkgs, ... }:
let inherit (pkgs.vimUtils) buildVimPlugin;
in buildVimPlugin {
  name = "cloak-nvim";
  src = inputs.cloak-nvim;
}
