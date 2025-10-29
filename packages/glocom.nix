{
  autoPatchelfHook,
  fetchurl,
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  pname = "glocom";
  version = "7.6.0";
  name = "${pname}-${version}";
  # buildInputs = with pkgs; [
  # ];
  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
  ];
  src = fetchurl {
    url = "https://downloads.bicomsystems.com/desktop/glocom/public/${version}/glocom/gloCOM-${version}.deb";
    # sha256 = pkgs.lib.fakeSha256;
    sha256 = "sha256-LLkQh4dVd9YagYPHEKWtdelmwfYlNnLJsyzm/U8h8Go=";
  };

  preBuild = ''
    addAutoPatchelfSearchPath $out/opt/gloCOM/lib/
  '';

  unpackPhase = ''
    mkdir -p "$out"
    ar x $src data.tar.xz
    tar -Jxf data.tar.xz -C "$out"
  '';
}
