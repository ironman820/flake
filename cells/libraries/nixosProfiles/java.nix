{
  cell,
  inputs,
  pkgs,
}: {
  programs.java = {
    binfmt = true;
    enable = true;
    package = pkgs.jdk17;
  };
}
