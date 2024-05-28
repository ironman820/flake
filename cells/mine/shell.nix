{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.std) lib std;

  l = nixpkgs.lib // builtins;
in
  l.mapAttrs (_: lib.dev.mkShell) {
    default = {...}: {
      name = "mine shell";
      imports = [
        std.devshellProfiles.default
      ];
      packages = with inputs.nixpkgs; [
        nix-index
        nix-tree
      ];
    };
  }
