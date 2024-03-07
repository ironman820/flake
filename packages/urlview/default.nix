{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.mine.vars.applications) browser;
  inherit (pkgs) urlscan;
in
  pkgs.writeShellScriptBin "urlview" ''
    ${urlscan}/bin/urlscan -s --run-safe '${pkgs.${browser}}/bin/${browser} {}' "$@"
  ''
