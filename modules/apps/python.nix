{
  flake.nixosModules.apps-python =
    {
      pkgs,
      ...
    }:
    let
      myPythonPackages =
        py: with py; [
          autopep8
          black
          cffi
          click
          dbus-next
          debugpy
          flake8
          isort
          jedi
          jedi-language-server
          jsonrpc-base
          lsprotocol
          mypy
          pip
          pre-commit-hooks
          psutil
          pygobject3
          pynvim
          pytest
          pytest-expect
          pytest-lazy-fixture
          pytest-raises
          pytest-tornado
          PyVirtualDisplay
          qtile
          rich
          rope
          typing-extensions
          typing-inspect
          xcffib
          yapf
        ];
    in
    {
      environment.systemPackages = with pkgs; [
        imagemagick
        pre-commit
        pyright
        (python3.withPackages myPythonPackages)
      ];
    };
}
