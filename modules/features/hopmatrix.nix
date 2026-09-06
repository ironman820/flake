{
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.hopmatrix = moduleWithSystem (
    perSystem@{ self', ... }:
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkIf mkPackageOption;
    in
    {
      options.programs.hopmatrix = {
        enable = mkEnableOption "Install hopmatrix";
        package = mkPackageOption self'.packages "hopmatrix" { };
      };
      config =
        let
          cfg = config.programs.hopmatrix;
        in
        mkIf cfg.enable {
          environment.systemPackages = [
            cfg.package
          ];
          security.wrappers.HopMatrix = {
            owner = "root";
            group = "pcap";
            capabilities = "cap_net_raw+p";
            source = "${cfg.package}/bin/HopMatrix-linux-x64";
          };
          users.users.${config.ironman.user.name}.extraGroups = [
            "pcap"
          ];
        };
    }
  );
  perSystem =
    {
      lib,
      pkgs,
      self',
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
