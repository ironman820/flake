{
  inputs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  name = "plymouth-themes";
  version = "2023-08-22";
  src = inputs.plymouth-themes;
  buildPhase = ''
    mkdir -p $out/share/plymouth/themes
    cp -r $src/pack_1/* $out/share/plymouth/themes/
    cp -r $src/pack_2/* $out/share/plymouth/themes/
    cp -r $src/pack_3/* $out/share/plymouth/themes/
    cp -r $src/pack_4/* $out/share/plymouth/themes/
  '';
  phases = "buildPhase";
}
