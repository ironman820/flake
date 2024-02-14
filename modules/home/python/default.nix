{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.python;
  myPythonPackages = py:
    with py; [
      black
      cffi
      dbus-next
      debugpy
      flake8
      jedi
      jedi-language-server
      jsonrpc-base
      lsprotocol
      mypy
      pre-commit-hooks
      pygobject3
      pytest
      pytest-expect
      pytest-lazy-fixture
      pytest-raises
      pytest-tornado
      PyVirtualDisplay
      qtile
      rope
      typing-extensions
      typing-inspect
      xcffib
      yapf
    ];
in {
  options.mine.home.python = {
    enable = mkBoolOpt true "Install the python interpreter";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      imagemagick
      pre-commit
      pyright
      (python3.withPackages myPythonPackages)
    ];
  };
}
