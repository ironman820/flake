{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nix-index
    nix-tree
  ];

  # shellHook = ''
  #   export NIX_PATH=nixpkgs=https://github.com/nixos/nixpkgs/archive/e516ffb.tar.gz
  # '';
}
