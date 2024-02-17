{ inputs, pkgs, ... }:

let inherit (pkgs.stdenv) mkDerivation;
in mkDerivation rec {
  buildPhase = ''
    mkdir -p $out
    cp -r $src/basic/.local/share/rofi/themes/* $out/
  '';
  name = pname;
  pname = "catppuccin-rofi";
  phases = "buildPhase";
  src = inputs.catppuccin-rofi;
}
