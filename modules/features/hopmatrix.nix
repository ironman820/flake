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
            group = "root";
            capabilities = "cap_net_raw+p";
            source = "${self'.packages.hopmatrix-unwrapped}/bin/HopMatrix-linux-x64";
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
        # hopmatrix =
        #   let
        #     libPath = lib.makeLibraryPath (
        #       with pkgs;
        #       [
        #         fontconfig
        #         icu
        #         libice
        #         libsm
        #         libx11
        #         zlib
        #       ]
        #     );
        #   in
        #   pkgs.writeShellScriptBin "hopmatrix" ''
        #     export LD_LIBRARY_PATH="${libPath}:$LD_LIBRARY_PATH"
        #     export PATH="${pkgs.nmap}/bin:$PATH"
        #     exec -a "$0" ${lib.getExe self'.packages.hopmatrix-unwrapped} "$@"
        #   '';
        hopmatrix = pkgs.stdenv.mkDerivation {
          pname = "hopmatrix-unwrapped";
          version = "2026.09.05";
          src = builtins.fetchurl {
            url = "https://download.redeyenetworks.com/hopmatrix/releases/latest/HopMatrix-linux-x64";
            sha256 = "1d930c7zpr4xgffad63p43wmqkfqja36bvf5nhzxjhi0vavxd3kp";
          };

          # sourceRoot = ".";
          dontUnpack = true;
          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp $src $out/bin/hopmatrix
            chmod +x $out/bin/hopmatrix
            runHook postInstall
          '';

          preFixup =
            let
              libPath = lib.makeLibraryPath (with pkgs; [
                fontconfig
                icu
                libice
                libsm
                libx11
                zlib
                stdenv.cc.cc.lib
              ]);
            in ''
              patchelf \
                --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                --set-rpath "${libPath}" \
                $out/bin/hopmatrix
            '';

          meta = {
            mainProgram = "hopmatrix";
          };
        };
      };
    };
}
