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
          security.wrappers = {
            hopmatrix = {
              owner = "root";
              group = "wheel";
              capabilities = "cap_net_raw+eip";
              source = "${self'.packages.hopmatrix}/bin/hopmatrix";
            };
            HopMatrix-linux-x64 = {
              owner = "root";
              group = "wheel";
              capabilities = "cap_net_raw+eip";
              source = "${self'.packages.hopmatrix-unwrapped}/bin/HopMatrix-linux-x64";
            };
          };
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
      packages = {
        hopmatrix =
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
          in
          pkgs.writeShellScriptBin "hopmatrix" ''
            export LD_LIBRARY_PATH="${libPath}:$LD_LIBRARY_PATH"
            export PATH="${pkgs.nmap}/bin:$PATH"
            exec -a "$0" ${lib.getExe self'.packages.hopmatrix-unwrapped} "$@"
          '';
        hopmatrix-unwrapped = pkgs.stdenv.mkDerivation {
          pname = "hopmatrix-unwrapped";
          version = "2026.09.05";
          src = builtins.fetchurl {
            url = "https://download.redeyenetworks.com/hopmatrix/releases/latest/HopMatrix-linux-x64";
            sha256 = "1d930c7zpr4xgffad63p43wmqkfqja36bvf5nhzxjhi0vavxd3kp";
          };

          # sourceRoot = ".";
          # dontUnpack = true;
          # dontConfigure = true;
          # dontBuild = true;
          # dontPatch = true;
          phases = [
            "installPhase"
          ];

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp $src $out/bin/HopMatrix-linux-x64
            chmod +x $out/bin/HopMatrix-linux-x64
            runHook postInstall
          '';

          # preFixup =
          #   let
          #     libPath = lib.makeLibraryPath (with pkgs; [
          #       fontconfig
          #       icu
          #       libice
          #       libsm
          #       libx11
          #       zlib
          #       stdenv.cc.cc.lib
          #     ]);
          #   in ''
          #     patchelf \
          #       --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          #       --set-rpath "${libPath}" \
          #       $out/bin/hopmatrix
          #   '';

          meta = {
            mainProgram = "HopMatrix-linux-x64";
          };
        };
      };
    };
}
