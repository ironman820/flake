{ config, lib, pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
  # buildInputs = with pkgs; [
  #   p7zip
  # ];

  # dontBuild = true;
  # dontFixup = true;

  # installPhase = ''
  #   rm -rf $out/iso/\[BOOT]
  # '';

  name = "${pname}";
  pname = "ubuntuserver";

  src = builtins.fetchurl {
    url = "https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/jammy-live-server-amd64.iso";
    sha256 = "sha256:ddbd459ffcaae42d907b5d017d85bad193033a92af669c3daa16d454baadc373";
  };

  # unpackPhase = ''
  #   7z x $src -o$out/iso
  # '';
}
