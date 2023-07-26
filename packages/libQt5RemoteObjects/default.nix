{ autoPatchelfHook, gcc-unwrapped, lib, pkgs, stdenv, ... }:
let
  version = "5.15.3";
  hash = "sha256:0hr5i4lrx4d6fdmynxbf51llnwkkw43bfb8p6qxhxil931lz9xmc";

  myBuildInputs = with pkgs; [
    gcc-unwrapped
  ];

in stdenv.mkDerivation rec {
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv ./usr/* $out/
    rm -rf usr

    runHook postInstall
  '';

  meta = with lib; {
    description = "Qt5 Remote Objects Module";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.free;
    maintainers = with maintainers; [ ironman820 ];
    platforms = [ "x86_64-linux" ];
  };

  nativeBuildInputs = (with pkgs; [
    autoPatchelfHook
    dpkg
    zstd
    qt512.wrapQtAppsHook
  ]) ++ myBuildInputs;

  pname = "libQt5RemoteObjects";

  src = builtins.fetchurl {
    url = "http://archive.ubuntu.com/ubuntu/pool/universe/q/qtremoteobjects-everywhere-src/libqt5remoteobjects5_5.15.3-1_amd64.deb";
    sha256 = hash;
  };

  unpackPhase = ''
    ar p "$src" data.tar.zst | tar x --zstd ./usr/
  '';

  inherit version;
}
