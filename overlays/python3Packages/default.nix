{channels, ...}: final: prev: rec {
  python3 = prev.python3.override {
    packageOverrides = final2: prev2: {
      inherit (channels.unstable.python3Packages) qtile;
      pyright = prev2.buildPythonPackage {
        pname = "pyright";
        version = "1.1.337";
        src = prev.fetchurl {
          url = "https://files.pythonhosted.org/packages/18/8d/43d0d60671fb6a91bad39e02dcf89da8e105709ad5d8628846886ceee2f4/pyright-1.1.337-py3-none-any.whl";
          sha256 = "0npnnmxfydd7wg884827kx3i64n9r5cag4w3da0qy9cp2zvlxgcc";
        };
        format = "wheel";
        doCheck = false;
        buildInputs = [];
        checkInputs = [];
        nativeBuildInputs = [];
        propagatedBuildInputs = [prev2.nodeenv];
      };
      qtile-extras =
        channels.unstable.python3Packages.qtile-extras.overridePythonAttrs
        (old: {disabledTestPaths = ["test/widget/test_strava.py"];});
      tendo = prev2.buildPythonPackage {
        pname = "tendo";
        version = "0.3.0";
        src = prev.fetchurl {
          url = "https://files.pythonhosted.org/packages/ce/3f/761077d55732b0b1a673b15d4fdaa947a7c1eb5c9a23b7142df557019823/tendo-0.3.0-py3-none-any.whl";
          sha256 = "1rrvp5w2w3i697zjkqrl3cy9ij40qbas4gqjqakrsk7aanrp0sq2";
        };
        format = "wheel";
        doCheck = false;
        buildInputs = [];
        checkInputs = [];
        nativeBuildInputs = [];
        propagatedBuildInputs = [
          prev2.six
        ];
      };
    };
  };
  python3Packages = python3.pkgs;
}
