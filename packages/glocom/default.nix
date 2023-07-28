{ autoPatchelfHook, channels, gcc-unwrapped, lib, pkgs, stdenv, ... }:
let
  myBuildInputs = (with pkgs; [
    # alsa-lib
    # dbus.lib
    # expat
    # ffmpeg
    # fontconfig.lib
    # freetype
    # glib.out
    # gtk2-x11
    # libxkbcommon
    nixgl.auto.nixGLDefault
    #   nss
    #   nspr
    #   openssl
    #   pulseaudio
    #   postgresql.lib
    #   qgnomeplatform
    #   unixODBC
    # ]) ++ (with pkgs.xorg; [
    #   libX11
    #   libxcb
    #   libXcomposite
    #   libXfixes
    #   libXi
    #   libXScrnSaver
    #   libXrandr
    #   libXrender
    #   libXtst
    #   libXcursor
    #   libXdamage
  ]) ++ qtInputs;

  qtInputs = (with pkgs.ironman; [
    libQt5RemoteObjects
    # ]) ++ (with pkgs.libsForQt5; [
    #   # full
    #   qt3d
    #   qt5ct
    #   qtbase
    #   qtdeclarative
    #   qtgamepad
    #   qtlocation
    #   qtquick1
    #   qtquickcontrols
    #   qtquickcontrols2
    #   qtstyleplugins
    #   qtsvg
    #   qtwayland
    #   qtwebengine
    #   qtx11extras
    #   qtxmlpatterns
  ]);

  sha256 = "sha256-QbTEjkgASd86CJrOTFFhw1t+TKPEHKl2P045lHQB0pA=";
  version = "6.7.4";

in
stdenv.mkDerivation rec {
  # autoPatchelfIgnoreMissingDeps = [
  #   "libQt5RemoteObjects.so.5"
  # ];

  dontBuild = true;
  dontConfigure = true;
  dontPatch = true;
  # dontPatchShebangs = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv ./opt/gloCOM/* ./usr/* $out/
    rm -rf opt
    rm -rf usr
    chmod -R 755 $out/bin

    mkdir -p $out/share/.gloCOM
    touch $out/share/.gloCOM/glocom.id
    chmod -R 777 $out/share/.gloCOM

    runHook postInstall
  '';

  meta = with lib; {
    # broken = true;
    description = "A unified communications software for use with Bicom Systems' PBXWare.";
    homepage = "https://bicomsystems.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # license = licenses.unfree;
    maintainers = with maintainers; [ ironman820 ];
    platforms = [ "x86_64-linux" ];
  };

  buildInputs = with pkgs; [
    # autoPatchelfHook
    dpkg
    qt5.wrapQtAppsHook
  ];

  nativeBuildInputs = myBuildInputs;

  pname = "glocom";

  libPath = "$out/lib:$out/qml:$out/share:" + (lib.makeLibraryPath ([ pkgs.stdenv.cc.cc ] ++ myBuildInputs ++ qtInputs));
  nixLd = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  qtPath = "$out/lib:$out/qml:$out/share:" + (lib.makeLibraryPath qtInputs);

  postFixup = ''
    sed -i "s|#/bin/sh|#!/usr/bin/env sh|" ${scriptName}
    sed -i "s|\$APP_NAME|gloCOM|g" ${scriptName}
    sed -i "s|/opt/gloCOM|$out|" ${scriptName}
    sed -i "s/\$1//" ${scriptName}
    sed -i "/QT_PLUGIN_PATH/d" ${scriptName}
    sed -i "s|$out/bin/gloCOM|${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL $out/bin/gloCOM|" ${scriptName}
    sed -i "s|/opt/gloCOM|$out|" $out/share/applications/gloCOM.desktop
    sed -i "s|/usr|$out|" $out/share/applications/gloCOM.desktop
    sed -i "s|/opt/gloCOM|$out|" $out/bin/qt.conf
    wrapQtApp "$out/bin/gloCOM"
  '';
  # sed -i "s|LD_LIBRARY_PATH.*$|NIX_LD_LIBRARY_PATH=\"${libPath}\"\nexport NIX_LD=${nixLd}|" ${scriptName}
  # sed -i "s|QT_PLUGIN_PATH.*|QT_PLUGIN_PATH=\"${qtPath}\"\nexport QT_QPA_PLATFORM=wayland|" ${scriptName}

  # preFixup = ''
  #   for path in $(echo "${lib.makeLibraryPath myBuildInputs}" | sed -r "s/:/ /g"); do
  #     addAutoPatchelfSearchPath $path
  #   done
  #   addAutoPatchelfSearchPath ${gcc-unwrapped}/lib
  # '';

  qtWrapperArgs = [
    ''--set QT_DEBUG_PLUGINS 1''
    ''--set QT_PKG_CONFIG true''
    ''--set QT_QPA_PLATFORM wayland''
    ''--set QT_QUICK_CONTROLS_STYLE gtk2''
    ''--set QT_STYLE_OVERRIDE gtk2''
    ''--prefix PATH : $out/lib:${lib.makeLibraryPath qtInputs}''
  ];

  scriptName = "$out/bin/glocom";

  src = builtins.fetchurl {
    url = "https://downloads.bicomsystems.com/desktop/glocom/public/${version}/glocom/gloCOM-${version}.deb";
    inherit sha256;
  };

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ ./usr/ ./opt/
  '';

  inherit version;
}
