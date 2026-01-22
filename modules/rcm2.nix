{ flakeRoot, ... }:
{
  flake.nixosModules.rcm2 =
    { pkgs, config, ... }:
    {
      environment = {
        systemPackages =
          let
            pythonPackages =
              let
                inherit (pkgs) fetchurl;
                inherit (pkgs.python3Packages) buildPythonPackage;
                p3p = pkgs.python3Packages;
                django-components = buildPythonPackage rec {
                  pname = "django-components";
                  version = "0.144.0";
                  src = fetchurl {
                    url = "https://files.pythonhosted.org/packages/a8/e2/9e2eb0c96ece2d043dd5eeac5063fbd60cea3a07661f57e67b2d43438252/django_components-0.144.0-py3-none-any.whl";
                    sha256 = "0az0iw3gib1xxpyrb6qm914pzlb7l0zx484k36b2lnx71qi5baay";
                  };
                  format = "wheel";
                  doCheck = false;
                  buildInputs = [ ];
                  checkInputs = [ ];
                  nativeBuildInputs = [ ];
                  propagatedBuildInputs = [
                    p3p.django
                    djc-core-html-parser
                    p3p.typing-extensions
                  ];
                };
                django-template-partials = buildPythonPackage rec {
                  pname = "django-template-partials";
                  version = "25.3";
                  src = fetchurl {
                    url = "https://files.pythonhosted.org/packages/9b/9d/48f8721e48b938ca2e2dde577986624543be6ff9bdccac20ccb747be4287/django_template_partials-25.3-py2.py3-none-any.whl";
                    sha256 = "0261yfj6wzmr31dcgf50qn6ggf12vzglsal03094w3pl9j9k94x1";
                  };
                  format = "wheel";
                  doCheck = false;
                  buildInputs = [ ];
                  checkInputs = [ ];
                  nativeBuildInputs = [ ];
                  propagatedBuildInputs = [
                    p3p.django
                  ];
                };
                djc-core-html-parser = buildPythonPackage rec {
                  pname = "djc-core-html-parser";
                  version = "1.0.3";
                  src = fetchurl {
                    url = "https://files.pythonhosted.org/packages/e0/49/d44e902ae54815ba7c54f1437c19fd5897ba361a07653935154a30d5a6d1/djc_core_html_parser-1.0.3.tar.gz";
                    sha256 = "0pvi9mk2xi4cfzans5jmjcn3aaia2m69mxmnhafp6afh81j5ap3k";
                  };
                  format = "pyproject";
                  doCheck = false;
                  buildInputs = [ ];
                  checkInputs = [ ];
                  nativeBuildInputs = [ ];
                  propagatedBuildInputs = [
                    maturin
                  ];
                };
                maturin = buildPythonPackage rec {
                  pname = "maturin";
                  version = "1.11.5";
                  src = fetchurl {
                    url = "https://files.pythonhosted.org/packages/a4/84/bfed8cc10e2d8b6656cf0f0ca6609218e6fcb45a62929f5094e1063570f7/maturin-1.11.5.tar.gz";
                    sha256 = "0a8cld2r1cyaq54w6m9h6kq06cpnrd1ag0zy35d5kf8gci3wyybm";
                  };
                  format = "setuptools";
                  doCheck = false;
                  buildInputs = [ ];
                  checkInputs = [ ];
                  nativeBuildInputs = [
                    pkgs.rustPlatform.cargoSetupHook
                  ];
                  propagatedBuildInputs = [
                    p3p.setuptools-rust
                    p3p.tomli
                  ];
                  unpackPhase = ''
                    # mkdir -p $out
                    # tar xzf $src -C $out
                    # mv $out/maturin-1.11.5/* $out/
                    # mv $out/maturin-1.11.5/.* $out/
                    # rmdir $out/maturin-1.11.5
                    tar xzf $src
                    mv maturin-1.11.5/* ./
                    mv maturin-1.11.5/.* ./
                    rmdir maturin-1.11.5
                  '';
                };
              in
              pkgs.python3.withPackages (
                ps: with ps; [
                  channels
                  channels-redis
                  daphne
                  django
                  django-components
                  django-extensions
                  django-htmx
                  django-template-partials
                  numpy
                  pandas
                  pillow
                  pyodbc
                  python-dotenv
                  redis
                  requests
                  sqlalchemy
                ]
              );
          in
          with pkgs;
          [
            pyright
            pythonPackages
            unixODBC
            (unixODBCDrivers.msodbcsql17.override { openssl = pkgs.openssl_1_1; })
          ];
        unixODBCDrivers = with pkgs.unixODBCDrivers; [
          (msodbcsql17.override { openssl = pkgs.openssl_1_1; })
        ];
        variables = {
          LD_LIBRARY_PATH = "/run/opengl-driver/lib:${pkgs.unixODBC}/lib:${pkgs.unixODBCDrivers.msodbcsql17}/lib";
        };
      };
      networking.firewall.allowedTCPPorts = [ 443 ];
      services = {
        # nginx = {
        #   enable = true;
        # };
      };
      # sops.secrets = {
      #   rcm_cert = {
      #     format = "binary";
      #     mode = "0400";
      #     owner = config.users.users.nginx.name;
      #     sopsFile = "${flakeRoot}/.secrets/rcm-cert.pem";
      #   };
      #   rcm_key = {
      #     format = "binary";
      #     mode = "0400";
      #     owner = config.users.users.nginx.name;
      #     sopsFile = "${flakeRoot}/.secrets/rcm-key.pem";
      #   };
      # };
      users.users.${config.ironman.user.name}.extraGroups = [
        config.services.nginx.group
      ];
    };
}
