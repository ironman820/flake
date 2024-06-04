{
  cell,
  inputs,
}: let
  inherit (inputs) haumea nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // haumea.lib // mine.lib // builtins;
in {
  bee = rec {
    pkgs = import inputs.nixpkgs {
      inherit system;
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = ["openssl-1.1.1w"];
    };
    system = "x86_64-linux";
  };
}
