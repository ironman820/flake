{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenvNoCC) mkDerivation;
  inherit (pkgs.qt5) qtbase qtgraphicaleffects qtquickcontrols2 qtsvg wrapQtAppsHook;
in
  mkDerivation {
    dontBuild = true;
    pname = "tokyo-night-sddm";
    version = "1.0";

    nativeBuildInputs = [
      wrapQtAppsHook
    ];

    propagatedUserEnvPkgs = [
      qtbase
      qtgraphicaleffects
      qtquickcontrols2
      qtsvg
    ];

    src = inputs.tokyo-night-sddm;

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/tokyo-night-sddm
    '';

    postFixup = ''
      sed -i 's|Backgrounds/win11.png|Backgrounds/shacks.png|' $out/share/sddm/themes/tokyo-night-sddm/theme.conf
    '';
  }
