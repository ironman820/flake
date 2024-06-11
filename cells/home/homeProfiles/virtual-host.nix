{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = [
    nixpkgs.virt-manager
  ];
}
