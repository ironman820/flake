{
  cell,
  inputs,
  pkgs,
}: {
  home.packages = with pkgs; [
    gcc
    glibc
    gnumake
  ];
}
