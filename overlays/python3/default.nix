{
  inputs,
  system,
  ...
}: final: prev: rec {
  inherit (inputs.unstable.legacyPackages.${system}) qtile;
  python3 = prev.python3.override {
    packageOverrides = final2: prev2: {
      inherit (inputs.unstable.legacyPackages.${system}.python3Packages) qtile-extras;
    };
  };
  python3Packages = python3.pkgs;
}
