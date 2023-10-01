{
    # Snowfall Lib provides a customized `lib` instance with access to your flake's library
    # as well as the libraries available from your flake's inputs.
    lib,
    # You also have access to your flake's inputs.
    inputs,

    # All other arguments come from NixPkgs. You can use `pkgs` to pull packages or helpers
    # programmatically or you may add the named attributes as arguments here.
    pkgs,
    stdenv,
    python310Packages,
    ...
}:
let
  inherit (python310Packages) buildPythonApplication pydbus six tendo tkinter;
in
buildPythonApplication {
  name = "myalarm";
  pname = "myalarm.py";
  version = "1.1";

  propagatedBuildInputs = ([
    pydbus
    six
    tendo
    tkinter
  ]);

  src = ./.;

}
