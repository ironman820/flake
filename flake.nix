{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      (
        let
          lib = inputs.nixpkgs.lib.extend (
            final: prev: { mine = import ./modules/_lib.nix { lib = prev; }; }
          );
        in
        inputs.import-tree ./modules
      );
}
