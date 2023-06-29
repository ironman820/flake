{pkgs, lib, ...}:
let
  version = "6.7.4";
  hash = "sha256-QbTEjkgASd86CJrOTFFhw1t+TKPEHKl2P045lHQB0pA=";

  rpath = lib.makeLibraryPath (with pkgs; [
    alsa-lib
    dbus.lib
    expat
    fontconfig.lib
    freetype
    libglvnd
    libsForQt5.qt5.qtwayland
    libxkbcommon
    gcc-unwrapped.lib
    gcc-unwrapped.libgcc
    glib
    glibc
    nspr
    nss
    pulseaudio
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXScrnSaver
    xorg.libXtst
  ]);

  qpath = lib.makeLibraryPath (with pkgs; [
    libsForQt5.qt5.qtwayland
  ]);

in pkgs.stdenv.mkDerivation {
  pname = "glocom";
  inherit version;

  src = builtins.fetchurl {
    url = "https://downloads.bicomsystems.com/desktop/glocom/public/${version}/glocom/gloCOM-${version}.deb";
    sha256 = hash;
  };

  nativeBuildInputs = with pkgs; [
    dpkg
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ ./usr/ ./opt/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv ./opt/gloCOM ./usr/share $out

    ln -s "$out/gloCOM/bin/glocom" "$out/bin/glocom"

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/gloCOM/bin/glocom --replace /opt $out \
      --replace /bin/sh "/usr/bin/env sh" \
      --replace \$APP_NAME gloCOM
    sed -i "s|LD_LIBRARY_PATH=\"|LD_LIBRARY_PATH=\"${rpath}:|" $out/gloCOM/bin/glocom
    sed -i "s|QT_PLUGIN_PATH=\"|QT_PLUGIN_PATH=\"${qpath}:|" $out/gloCOM/bin/glocom
    substituteInPlace $out/share/applications/gloCOM.desktop \
      --replace /opt $out --replace /usr $out
    substituteInPlace $out/gloCOM/bin/qt.conf --replace /opt $out

    for file in "$out/gloCOM/bin/gloCOM"; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpath}" \
        $file
      patchelf --shrink-rpath $file
      strip $file
    done
  '';
      # --replace $out/gloCOM/bin/gloCOM "ldd $out/gloCOM/bin/gloCOM"

  meta = with lib; {
    broken = true;
    description = "A unified communications software for use with Bicom Systems' PBXWare.";
    homepage = "https://bicomsystems.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ ironman820 ];
    platforms = [ "x86_64-linux" ];
  };
}