{ inputs, pkgs, ... }:

let inherit (pkgs.stdenv) mkDerivation;
in mkDerivation rec {
  buildPhase = ''
    mkdir -p $out
    cp -r $src/extras/lazygit/* $out/
  '';
  name = pname;
  pname = "tokyonight-lazygit";
  phases = "buildPhase";
  src = inputs.tokyonight;
  version = inputs.tokyonight.rev;
}
