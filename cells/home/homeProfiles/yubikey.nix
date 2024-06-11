{
  cell,
  inputs,
  pkgs,
}: {
  home.packages = [
    pkgs.yubioath-flutter
  ];
  programs.gpg = {
    scdaemonSettings = {
      reader-port = "Yubico";
      disable-ccid = true;
      pcsc-shared = true;
    };
  };
}
