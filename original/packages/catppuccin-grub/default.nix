{ inputs, pkgs, ... }:
let inherit (pkgs.stdenv) mkDerivation;
in mkDerivation rec {
  buildPhase = ''
    mkdir -p $out/share/grub/themes
    cp -aR $src/src/* $out/share/grub/themes/
  '';
  name = pname;
  phases = "buildPhase";
  pname = "catppuccin-grub";
  src = inputs.catppuccin-grub;
  version = "2022-12-29";
}
