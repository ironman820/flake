{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    gcc
    glibc
    gnumake
  ];
}
