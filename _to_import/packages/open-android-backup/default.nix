{
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  buildPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin/
    mv $out/bin/backup.sh $out/bin/open-android-backup
  '';
  name = "open-android-backup";
  propagatedBuildInputs = with pkgs; [
    bc
    curl
    dialog
    p7zip
    pv
  ];
  src = pkgs.fetchzip {
    hash = "sha256-ak3mOENbQ3W3iWZaEIabojaLfyatizs7tG2KSUgtAhM=";
    stripRoot = false;
    url = "https://github.com/mrrfv/open-android-backup/releases/download/v1.0.16/Open_Android_Backup_v1.0.16_Bundle.zip";
  };
  version = "1.0.16";
}
