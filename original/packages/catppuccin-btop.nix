{ inputs, pkgs, ... }:

let inherit (pkgs.stdenv) mkDerivation;
in mkDerivation rec {
  buildPhase = ''
    mkdir -p $out
    cp $src/themes/* $out/
  '';
  name = pname;
  pname = "catppuccin-btop";
  version = inputs.catppuccin-btop.rev;
  phases = "buildPhase";
  src = inputs.catppuccin-btop;
}
