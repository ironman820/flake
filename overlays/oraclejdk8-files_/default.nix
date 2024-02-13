{ channels, ... }:
prev: final:
let
  files = {
    "jdk-8u281-linux-x64.tar.gz" = ./files/jdk-8u281-linux-x64.tar.gz;
  };
in
{
  requireFile = args @ {name, url, sha1 ? null, sha256 ? null}:
    if files?${name} then
      prev.stdenvNoCC.mkDerivation {
        inherit name;
        outputHashMode = "flat";
        outputHashAlgo = if sha256 != null then "sha256" else "sha1";
        outputHash     = if sha256 != null then  sha256  else  sha1 ;
        buildCommand   = "cp ${files.${name}} $out";
      }
    else
      final.requireFile args;
}
