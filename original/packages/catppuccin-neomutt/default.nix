{ inputs, pkgs, ... }:

let inherit (pkgs.stdenv) mkDerivation;
in mkDerivation rec {
  buildPhase = ''
    mkdir -p $out
    cp -r $src/neomuttrc $out/catppuccin-neomutt
  '';
  name = pname;
  pname = "catppuccin-neomutt";
  phases = "buildPhase";
  src = inputs.catppuccin-neomutt;
}
