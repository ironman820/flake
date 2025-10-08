{pkgs, ...}: let
  inherit (pkgs.python3Packages) buildPythonApplication aiohttp;
  myPkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "my-old-revision";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "0c159930e7534aa803d5cf03b27d5c86ad6050b7";
  }) {inherit (pkgs) system;};
  name = "idracclient";
  pname = "idracclient";
  idracclient = buildPythonApplication {
    inherit name pname version;

    propagatedBuildInputs = [
      aiohttp
    ];

    src = ./.;
  };
  version = "1.1";
  jdk = myPkgs.openjdk7;
in
  pkgs.writeShellScriptBin "idrac" ''
    #!/usr/bin/env bash

    ${idracclient}/bin/idracclient.py --java ${jdk}/bin/java $@
  ''
