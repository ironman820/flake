{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenvNoCC) mkDerivation;
  inherit
    (pkgs.qt5)
    qtbase
    qtgraphicaleffects
    qtquickcontrols2
    qtsvg
    wrapQtAppsHook
    ;
in
  mkDerivation {
    dontBuild = true;
    pname = "sddm-catppuccin";
    version = "1.0";

    nativeBuildInputs = [wrapQtAppsHook];

    propagatedUserEnvPkgs = [qtbase qtgraphicaleffects qtquickcontrols2 qtsvg];

    src = inputs.sddm-catppuccin;

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/src/* $out/share/sddm/themes/
    '';
  }
