{ inputs, pkgs, ... }:

let inherit (pkgs.stdenv) mkDerivation;
in mkDerivation rec {
  buildPhase = ''
    mkdir -p $out
    cp $src/themes/* $out/
  '';
  name = pname;
  pname = "catppuccin-btop";
  phases = "buildPhase";
  src = inputs.catppuccin-btop;
}
