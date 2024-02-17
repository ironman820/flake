{
  inputs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  buildPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
  name = "catppuccin-yazi";
  phases = "buildPhase";
  version = "0.1";
  src = inputs.catppuccin-yazi;
}
