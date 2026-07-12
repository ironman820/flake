{ inputs, pkgs, ... }:
let
  inherit (pkgs.python3Packages) buildPythonPackage;
  custom_rust_toolchain = pkgs.rust-bin.stable.latest.default;
  craneLib = (inputs.crane.mkLib pkgs).overrideToolchain custom_rust_toolchain;
  crate_artifacts = craneLib.buildDepsOnly (
    crate_cfg
    // {
      pname = "${project_name}-artifacts";
      version = project_version;
    }
  );
  crate_cfg = {
    src = craneLib.cleanCargoSource (craneLib.path ./.);
    nativeBuildInputs = [ python_version ];
  };
  crate_wheel =
    (craneLib.buildPackage (
      crate_cfg
      // {
        pname = project_name;
        version = project_version;
        cargoArtifacts = crate_artifacts;
      }
    )).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.maturin ];
        buildPhase = old.buildPhase + ''
          maturin build --offline --target-dir ./target
        '';
        installPhase = old.installPhase + ''
          cp target/wheels/${project_name}-${project_version}-${wheel_tail}.whl $out/
        '';
      });
  project_name = "djc_core_html_parser";
  project_version = "1.0.3";
  python_version = pkgs.python3;
  wheel_tail = "cp314-cp314-linux_x86_64";
in
buildPythonPackage rec {
  name = project_name;
  pname = project_name;
  version = project_version;
  src = "${crate_wheel}/${project_name}-${project_version}-${wheel_tail}.whl";
  format = "wheel";
  doCheck = false;
  pythonImportsCheck = [ project_name ];
}
