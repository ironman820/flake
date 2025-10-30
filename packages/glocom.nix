{
  autoPatchelfHook,
  fetchurl,
  inputs,
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  pname = "glocom";
  version = "7.6.0";
  name = "${pname}-${version}";
  # autoPatchelfIgnoreMissingDeps = [
  #   "libQt5Network.so.5"
  #   "libQt5Core.so.5"
  # ];
  buildInputs = (with pkgs; [
    alsa-lib
    # gst_all_1.gst-plugins-base
    # libgbm
    # libgcc.lib
    # libpq
    # libpulseaudio
    # libxkbcommon
    mysql80
    nss
    pyfa
    robo3t
    # xorg.libX11
    # xorg.libXdamage
    xorg.libxkbfile
    # xorg.libXrandr
    xorg.libxshmfence
    # xorg.xcbutilimage
  ])
  ++ (with inputs.nixpkgs-8cad3db.legacyPackages.${pkgs.system}.qt6; [
    qtbase
    qtdeclarative
    qtquicktimeline
    qtscxml
    qt5compat
    qtwayland
  ]);
  nativeBuildInputs = [
    autoPatchelfHook
    inputs.nixpkgs-8cad3db.legacyPackages.${pkgs.system}.qt6.wrapQtAppsHook
  ];
  src = fetchurl {
    url = "https://downloads.bicomsystems.com/desktop/glocom/public/${version}/glocom/gloCOM-${version}.deb";
    # sha256 = pkgs.lib.fakeSha256;
    sha256 = "sha256-LLkQh4dVd9YagYPHEKWtdelmwfYlNnLJsyzm/U8h8Go=";
  };

  preBuild = ''
    addAutoPatchelfSearchPath $out/opt/gloCOM/lib/
    addAutoPatchelfSearchPath ${pkgs.robo3t}/lib/robo3t/lib/
    addAutoPatchelfSearchPath ${pkgs.pyfa}/share/pyfa/app/
  '';

  unpackPhase = ''
    mkdir -p "$out"
    ar x $src data.tar.xz
    tar -Jxf data.tar.xz -C "$out"
  '';
}
