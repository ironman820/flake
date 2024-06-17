{
  cell,
  inputs,
}: let
  inherit (inputs.nixpkgs) system;
in
  inputs.nixpkgs.extend
  (_: _: {inherit (inputs.nixpkgs-2311.legacyPackages.${system}) openssh;})
