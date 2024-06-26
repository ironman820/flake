{pkgs, ...}: let
  inherit (pkgs.python3Packages) buildPythonApplication;
  name = "convertToHtmlMultipart";
  pname = "convertToHtmlMultipart";
  version = "1.1";
in
  buildPythonApplication {
    inherit name pname version;

    buildInputs = with pkgs; [
      pandoc
    ];
    propagatedBuildInputs = [
    ];

    src = ./.;
  }
