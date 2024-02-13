{ inputs
, pkgs
}:
let
    inherit (pkgs.vimUtils) buildVimPlugin;
in buildVimPlugin {
    name = "undotree";
    src = inputs.nvim-undotree;
}
