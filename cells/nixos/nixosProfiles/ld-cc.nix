{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  environment = {
    shellInit = ''
      export NIX_LD=$(cat "${nixpkgs.stdenv.cc}/nix-support/dynamic-linker")
    '';
    variables = l.mkForce {
      NIX_LD_LIBRARY_PATH = l.makeLibraryPath [
        nixpkgs.stdenv.cc.cc
      ];
    };
  };
}
