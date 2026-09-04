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
      packages.hopmatrix = pkgs.stdenv.mkDerivation {
        pname = "hopmatrix";
        version = "2026.09.04";
        src = builtins.fetchurl {
          url = "https://download.redeyenetworks.com/hopmatrix/releases/latest/HopMatrix-linux-x64";
          sha256 = "1fbkdrvarjv6hx2jxi75v2rpbvsdf4nz0ylkc3ffakwyq1b87s0l";
        };

        phases = [
          "installPhase"
        ];

        runtime
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp $src $out/bin/hopmatrix
          chmod +x $out/bin/hopmatrix
          runHook postInstall
        '';
      };
    };
}
