{
  inputs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  name = "base16-onedark-scheme";
  version = "2018-01-04";
  src = inputs.base16-schemes;
  buildPhase = ''
    mkdir -p $out
    cp $src/onedark.yaml $out/theme.yaml
  '';
  phases = "buildPhase";
}
