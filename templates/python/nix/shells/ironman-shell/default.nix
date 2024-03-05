{
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  name = "ironman-shell";
  nativeBuildInputs = with pkgs; [
    nix-index
    nix-tree
    python3
    poetry
  ];
}
