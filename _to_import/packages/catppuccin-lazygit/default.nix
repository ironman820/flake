{ inputs, pkgs, ... }:

let inherit (pkgs.stdenv) mkDerivation;
in mkDerivation rec {
  buildPhase = ''
    mkdir -p $out
    cp -r $src/themes-mergable/* $out/
  '';
  name = pname;
  pname = "catppuccin-lazygit";
  phases = "buildPhase";
  src = inputs.catppuccin-lazygit;
}
