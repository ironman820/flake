{ lib
, inputs
, fetchFromGitHub
, pkgs
, stdenv
}:
let
    inherit (pkgs.vimUtils) buildVimPlugin;
in buildVimPlugin rec {
    name = "cmp-nerdfont";
    src = inputs.nvim-cmp-nerdfont;
}
