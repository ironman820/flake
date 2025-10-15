{ inputs, pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  buildPhase = ''
    mkdir -p $out
    cp $src/themes/* $out/
  '';
  name = pname;
  pname = "catppuccin-kitty";
  version = inputs.catppuccin-kitty.rev;
  phases = "buildPhase";
  src = inputs.catppuccin-kitty;
}
