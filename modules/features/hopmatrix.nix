{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  perSystem =
    {
      # config,
      # inputs',
      lib,
      pkgs,
      self',
      # system,
      ...
    }:
    {
      apps.hopmatrix = {
        meta.description = "";
        program = self'.packages.hopmatrix;
      };
      packages.hopmatrix =
        let
          libPath = lib.makeLibraryPath (
            with pkgs;
            [
              fontconfig
              icu
              libice
              libsm
              libx11
              zlib
            ]
          );
          hopmatrix = pkgs.writeShellScript "hopmatrix" ''
            export LD_LIBRARY_PATH="${libPath}:$LD_LIBRARY_PATH"
            export PATH="${pkgs.nmap}/bin:$PATH"
            exec -a "$0" ./HopMatrix-linux-x64 "$@"
          '';
        in
        pkgs.stdenv.mkDerivation {
          pname = "hopmatrix";
          version = "2026.09.05";
          src = builtins.fetchurl {
            url = "https://download.redeyenetworks.com/hopmatrix/releases/latest/HopMatrix-linux-x64";
            sha256 = "0j8wyr3savs8j35kzhxlwimbrd3aibqkqw7cs62cn7pzcrbpj431";
          };

          sourceRoot = ".";
          dontUnpack = true;
          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp $src $out/bin/HopMatrix-linux-x64
            chmod +x $out/bin/HopMatrix-linux-x64
            cp ${hopmatrix} $out/bin/hopmatrix
            runHook postInstall
          '';

          meta = {
            mainProgram = "hopmatrix";
          };
        };
    };
}
