{ lib
, inputs
, fetchFromGitHub
, pkgs
, stdenv
}:

let
  inherit (pkgs.stdenv) mkDerivation;
in mkDerivation rec {
  buildPhase = ''
    mkdir -p $out/bin
    cp $src/session-wizard.sh $out/bin/t
    chmod +x $out/bin/t
  '';
  name = pname;
  pname = "t";
  phases = "buildPhase";
  src = inputs.tmux-session-wizard;
}
