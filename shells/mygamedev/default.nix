{ lib, inputs, pkgs, stdenv, ... }:
let
  python-packages = ps: with ps; [
    pydbus
    tkinter
  ];
  python = pkgs.python310.withPackages python-packages;
in
stdenv.mkDerivation {
  name = "mygamedev";
  nativeBuildInputs = ([
    python
  ]);

  shellHook = ''
    rm ~/.config/flake/packages/myalarm/.python
    ln -sf ${python} ~/.config/flake/packages/myalarm/.python
  '';
}
