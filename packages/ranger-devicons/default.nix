{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) mkDerivation;
in
  mkDerivation rec {
    buildPhase = ''
      mkdir -p $out/
      cp $src/* $out/
    '';
    name = pname;
    pname = "ranger-devicons";
    phases = "buildPhase";
    src = inputs.ranger-devicons;
  }
