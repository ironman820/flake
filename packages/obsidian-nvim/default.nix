{ inputs, pkgs, ... }:
let inherit (pkgs.vimUtils) buildVimPlugin;
in buildVimPlugin {
  name = "obsidian-nvim";
  src = inputs.obsidian-nvim;
}
