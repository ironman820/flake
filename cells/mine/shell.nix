{
  cell,
  inputs,
}: let
  inherit (inputs.cells) mine;
  inherit (inputs) haumea nixpkgs;
  inherit (inputs.std) lib std;

  l = nixpkgs.lib // haumea.lib // mine.lib // builtins;
in
  l.mapAttrs (_: lib.dev.mkShell) {
    default = {...}: {
      name = "mine shell";
      motd = l.mkForce ''

        {202}{bold}Welcome to the New Standard{reset}

        $(menu)
      '';
      imports = [
        std.devshellProfiles.default
      ];
      packages = with inputs.nixpkgs; [
        nix-index
        nix-tree
      ];
    };
  }
