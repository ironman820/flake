{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    yubioath-flutter
  ];
  programs.gpg = {
    scdaemonSettings = {
      reader-port = "Yubico";
      disable-ccid = true;
      pcsc-shared = true;
    };
  };
}
