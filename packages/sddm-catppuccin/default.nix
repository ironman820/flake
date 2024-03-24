{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenvNoCC) mkDerivation;
  inherit
    (pkgs.qt5)
    qtquickcontrols2
    ;
  inherit (pkgs.qt6) qtbase qtsvg wrapQtAppsHook;
in
  mkDerivation {
    dontBuild = true;
    pname = "sddm-catppuccin";
    version = "1.0";

    nativeBuildInputs = [qtbase wrapQtAppsHook];

    propagatedUserEnvPkgs = [qtbase qtquickcontrols2 qtsvg];

    src = inputs.sddm-catppuccin;

    installPhase = ''
      mkdir -p $out/share/sddm/themes/catppuccin-mocha/
      cp $src/pertheme/mocha.conf $out/share/sddm/themes/catppuccin-mocha/theme.conf
      cp -R $src/src/* $out/share/sddm/themes/catppuccin-mocha/
    '';
  }
