{channels, ...}: final: prev: rec {
  inherit (channels.unstable) qtile;
  python3 = prev.python3.override {
    packageOverrides = final2: prev2: {
      inherit (channels.unstable.python3Packages) qtile-extras;
    };
  };
  python3Packages = python3.pkgs;
}
