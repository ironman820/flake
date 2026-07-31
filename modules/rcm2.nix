{ flakeRoot, inputs, ... }:
{
  flake.nixosModules.rcm2 =
    { pkgs, config, ... }:
    let
      phpPkgs = import inputs.nixpkgs-php {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    in
    {
      environment =
        let
          version-utils = import "${flakeRoot}/lib/version-utils.nix" { };
          inherit (version-utils) getVersionMajorMinor;
          pythonPackages =
            let
              inherit (pkgs) fetchurl;
              inherit (pkgs.python3Packages) buildPythonPackage;
              p3p = pkgs.python3Packages;
              django-components = buildPythonPackage {
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
                  pkgs.local.djc-core-html-parser
                  p3p.typing-extensions
                ];
              };
              django-cotton = buildPythonPackage {
                pname = "django-cotton";
                version = "2.6.1";
                src = fetchurl {
                  url = "https://files.pythonhosted.org/packages/3d/d2/dea85f1931de0b2da4746f6ad669c7da1f5c8569bee144fe6620c8d98d61/django_cotton-2.6.1-py3-none-any.whl";
                  sha256 = "026bf5ai2dvbrilvcq7jwnwb2ihp4vmmf1givak373f06q1xlpbp";
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
              django-template-partials = buildPythonPackage {
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
              jinjax = buildPythonPackage {
                pname = "jinjax";
                version = "0.37";
                src = fetchurl {
                  url = "https://files.pythonhosted.org/packages/d1/fa/666249b379427b9c98b9ee8eda47ae490ccae175940f8df5b7ca668ffc65/jinjax-0.37-py3-none-any.whl";
                  sha256 = "07giqpnl383vks0kpwizh5xl56r334d877515rc4qzv1br4plnn4";
                };
                format = "wheel";
                doCheck = false;
                buildInputs = [ ];
                checkInputs = [ ];
                nativeBuildInputs = [ ];
                propagatedBuildInputs = with p3p; [
                  jinja2
                  markupsafe
                  whitenoise
                ];
              };
            in
            pkgs.python3.withPackages (
              ps: with ps; [
                attrs
                autobahn
                automat
                beautifulsoup4
                cffi
                channels
                channels-redis
                constantly
                coverage
                cryptography
                daphne
                django
                django-appconf
                django-compressor
                django-components
                django-cotton
                django-debug-toolbar
                django-extensions
                django-hijack
                django-htmx
                django-phonenumber-field
                django-template-partials
                django-widget-tweaks
                factory-boy
                faker
                hyperlink
                idna
                incremental
                ipykernel
                jinja2
                jinjax
                markupsafe
                msgpack
                numpy
                pandas
                phonenumberslite
                pillow
                psycopg2
                pyasn1
                pyasn1-modules
                pycparser
                pyodbc
                pyopenssl
                python-dotenv
                rcssmin
                redis
                requests
                rjsmin
                service-identity
                soupsieve
                sqlalchemy
                twisted
                txaio
                zope-interface
              ]
            );
        in
        {
          systemPackages = with pkgs; [
            conda
            nodejs
            basedpyright
            pythonPackages
            unixODBC
            (unixODBCDrivers.msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
          ];
          unixODBCDrivers = with pkgs.unixODBCDrivers; [
            (msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
          ];
          variables = {
            LD_LIBRARY_PATH = "/run/opengl-driver/lib:${pkgs.unixODBC}/lib:${pkgs.unixODBCDrivers.msodbcsql17}/lib";
            PYTHONPATH = "${pythonPackages}/lib/python${getVersionMajorMinor pkgs.python3.version}/site-packages";
          };
        };
      networking.firewall.allowedTCPPorts = [ 8000 ];
      users.users.${config.ironman.user.name}.extraGroups = [
        config.services.nginx.group
      ];
    };
}
