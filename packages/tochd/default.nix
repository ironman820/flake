{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs) p7zip mame-tools;
  inherit (pkgs.python3Packages) buildPythonApplication;
  name = "tochd";
  pname = "tochd";
  tochd = buildPythonApplication {
    inherit name pname version;

    propagatedBuildInputs = [
      p7zip
      mame-tools
    ];

    src = inputs.tochd;
  };
  version = "1.1";
in
  pkgs.writeShellScriptBin "tochd" ''
    #!/usr/bin/env bash

    echo "${tochd}/bin/tochd.py --7z \"${p7zip}/bin/7z\" --chdman \"${mame-tools}/bin/chdman\" $@"
    ${tochd}/bin/tochd.py --7z "${p7zip}/bin/7z" --chdman "${mame-tools}/bin/chdman" $@
  ''
