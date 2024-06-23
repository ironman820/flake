{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  inherit (inputs.std) lib std;
  l = nixpkgs.lib // mine.lib // builtins;
in
  l.mapAttrs (_: lib.dev.mkShell) {
    default = {...}: {
      imports = [
        std.devshellProfiles.default
      ];
      name = "mine shell";
      motd = l.mkForce ''

        {202}{bold}Welcome to the New Standard{reset}

        $(menu)
      '';
      packages = with nixpkgs; [
        colmena
        nix-index
        nix-tree
        tree
      ];
    };
  }
