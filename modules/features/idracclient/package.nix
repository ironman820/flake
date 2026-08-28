{
  perSystem =
    {
      self',
      pkgs,
      system,
      ...
    }:
    {
      apps.idracclient = {
        meta.description = "A wrapped iDRAC client made to work with iDRAC v6";
        program = self'.packages.NAME;
      };
      packages.idracclient =
        let
          inherit (pkgs.python3Packages) buildPythonApplication aiohttp setuptools;
          myPkgs = import (fetchGit {
            # Descriptive name to make the store path easier to identify
            name = "my-old-revision";
            url = "https://github.com/NixOS/nixpkgs/";
            ref = "refs/heads/nixpkgs-unstable";
            rev = "0c159930e7534aa803d5cf03b27d5c86ad6050b7";
          }) { inherit system; };
          name = "idracclient";
          pname = "idracclient";
          idracclient = buildPythonApplication {
            inherit name pname version;
            build-system = [ setuptools ];

            propagatedBuildInputs = [
              aiohttp
            ];
            pyproject = true;

            src = ./.;
          };
          version = "1.1";
          jdk = myPkgs.openjdk7;
        in
        pkgs.writeShellScriptBin "idrac" ''
          ${idracclient}/bin/idracclient.py --java ${jdk}/bin/java $@
        '';
    };
}
