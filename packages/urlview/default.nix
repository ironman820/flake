{pkgs, ...}: let
  inherit (pkgs) urlscan;
in
  pkgs.writeShellScriptBin "urlview" ''
    /usr/bin/env bash
    ${urlscan}/bin/urlscan "$@"
  ''
