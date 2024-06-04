{
  cell,
  inputs,
}: let
  inherit (inputs.nixpkgs.stdenv) mkDerivation;
in {
  base16-onedark-scheme = mkDerivation {
    name = "base16-onedark-scheme";
    version = "2018-01-04";
    src = inputs.base16-schemes;
    buildPhase = ''
      mkdir -p $out
      cp $src/onedark.yaml $out/theme.yaml
    '';
    phases = "buildPhase";
  };
  grub-cyberexs = mkDerivation {
    pname = "grub-cyberexs";
    version = "1.0";
    src = ./files/CyberEXS-1.0.0.tar.gz;
    unpackPhase = ''
      mkdir -p $out/share/grub/themes
      tar -xzf $src -C $out/share/grub/themes/
    '';
    phases = "unpackPhase";
  };
}
