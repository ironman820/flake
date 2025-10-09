{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) mkDerivation;
in
  mkDerivation rec {
    buildPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
    name = pname;
    pname = "catppuccin-starship";
    phases = "buildPhase";
    src = inputs.catppuccin-starship;
  }
