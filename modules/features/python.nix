{
  flake = {
    nixosModules.python =
      {
        pkgs,
        ...
      }:
      {
        environment = {
          localBinInPath = true;
          systemPackages = [
            pkgs.uv
          ];
        };
        programs.nix-ld = {
          enable = true;
          libraries = with pkgs; [
            stdenv.cc.cc.lib
            zlib
          ];
        };
      };
    homeModules.python = {
      programs.uv = {
        enable = true;
        python = {
          versions = [
            "3.14"
            "3.13"
          ];
          default = [ "3.14" ];
          prune = true;
        };
        tool = {
          packages = [
            "autopep8"
            "basedpyright"
            "black"
            "cffi"
            "debugpy"
            "flake8"
            "isort"
            "jedi-language-server"
            "mypy"
            "numpy"
            "pdfplumber"
            "pre-commit-hooks"
            "pymupdf"
            "pynvim"
            "pytest"
          ];
          prune = true;
        };
      };
    };
  };
}
