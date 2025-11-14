{
  autoPatchelfHook,
  fetchurl,
  inputs,
  pkgs,
  stdenv,
  ...
}:
let
  installPackages =
    (with pkgs; [
      alsa-lib
      dbus
      expat
      fontconfig
      freetype
      glib
      gst_all_1.gst-plugins-base
      krb5
      libgbm
      libGL
      libpulseaudio
      libx11
      libxfixes
      libxkbcommon
      libxrandr
      mysql80
      nspr
      nss
    ])
    ++ (with inputs.stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.qt6; [
      qt5compat
      qtbase
      qtdeclarative
      qtquicktimeline
      qtscxml
      qtwayland
    ])
    ++ (with pkgs.xorg; [
      libXcomposite
      libXdamage
      libxkbfile
      libxshmfence
      libXtst
    ]);
  libPath = pkgs.lib.makeLibraryPath installPackages;
in
stdenv.mkDerivation rec {
  pname = "glocom";
  version = "7.6.0";
  name = "${pname}-${version}";
  buildInputs = installPackages;
  nativeBuildInputs = with inputs.stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}; [
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ];
  autoPatchelfIgnoreMissingDeps = [
    "libQt5Network.so.5"
    "libQt5Core.so.5"
  ];
  src = fetchurl {
    url = "https://downloads.bicomsystems.com/desktop/glocom/public/${version}/glocom/gloCOM-${version}.deb";
    # sha256 = pkgs.lib.fakeSha256;
    sha256 = "sha256-LLkQh4dVd9YagYPHEKWtdelmwfYlNnLJsyzm/U8h8Go=";
  };

  sourceRoot = ".";
  unpackCmd = "${pkgs.dpkg}/bin/dpkg-deb -x ${src} .";

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -R usr/share opt $out/
    substituteInPlace $out/opt/gloCOM/bin/glocom --replace "export QT_PLUGIN_PATH=\"/opt/gloCOM/lib/plugins\"" "export QTWEBENGINE_RESOURCES_PATH=\"/opt/gloCOM/bin/data/resources\"; export QTWEBENGINE_LOCALES_PATH=\"/opt/gloCOM/bin/translations/qtwebengine_locales\"; export QT_QPA_PLATFORM=xcb; export QT_DEBUG_PLUGINS=1"
    substituteInPlace $out/opt/gloCOM/bin/glocom --replace /opt/ $out/opt/
    substituteInPlace $out/opt/gloCOM/bin/glocom --replace LD_LIBRARY_PATH=\" LD_LIBRARY_PATH=\"${libPath}:
    substituteInPlace $out/opt/gloCOM/bin/protocol_register --replace "#!/bin/bash" "#/bin/bash"
    substituteInPlace $out/opt/gloCOM/bin/protocol_register --replace echo "# echo"
    ln -s $out/opt/gloCOM/bin/glocom $out/bin/glocom

    runHook postInstall
  '';
  # substituteInPlace $out/opt/gloCOM/bin/glocom --replace /opt/\$APP_NAME/bin/\$APP_NAME "ldd /opt/\$APP_NAME/bin/\$APP_NAME"

  preFixupPhase = ''
    wrapQtApp "$out/opt/gloCOM/bin/gloCOM" --prefix PATH : "${libPath}:$out/opt/gloCOM/lib/plugins:$out/opt/gloCOM/qml"
  '';
  # patchelf --set-rpath "${libPath}" $out/opt/gloCOM/bin/gloCOM
}
