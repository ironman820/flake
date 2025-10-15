{ inputs, pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  buildPhase = ''
    mkdir -p $out/share/grub/themes/CyberEXS
    cp -r $src/* $out/share/grub/themes/CyberEXS/
  '';
  name = pname;
  pname = "grub-cyberexs";
  version = inputs.grub-cyberexs.rev;
  src = inputs.grub-cyberexs;
  phases = "buildPhase";
}
