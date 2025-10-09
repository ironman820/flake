{stdenv, ...}:
stdenv.mkDerivation {
  name = "grub-cyberexs";
  version = "1.0";
  src = ./files/CyberEXS-1.0.0.tar.gz;
  unpackPhase = ''
    mkdir -p $out/share/grub/themes
    tar -xzf $src -C $out/share/grub/themes/
  '';
  phases = "unpackPhase";
}
