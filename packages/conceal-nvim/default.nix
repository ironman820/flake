{ inputs, pkgs }:
let
    inherit (pkgs.vimUtils) buildVimPlugin;
in buildVimPlugin {
    name = "conceal-nvim";
    src = inputs.nvim-conceal;
}
