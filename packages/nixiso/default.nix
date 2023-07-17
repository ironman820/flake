{ config, lib, pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
  buildInputs = with pkgs; [
    p7zip
  ];

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    rm -rf $out/iso/\[BOOT]
  '';

  name = "${pname}";
  pname = "nixiso";

  src = builtins.fetchurl {
    url = "https://channels.nixos.org/nixos-23.05/latest-nixos-minimal-x86_64-linux.iso";
    sha256 = "sha256:a5015d93bf0f1232cdc698170e5e77c1ce7c2f952739cbf8e9853cb6d5f8927f";
  };

  unpackPhase = ''
    7z x $src -o$out/iso
  '';
}
