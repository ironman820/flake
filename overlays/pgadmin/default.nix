{
  inputs,
  system,
  ...
}: final: prev: {
  inherit (inputs.unstable.legacyPackages.${system}) pgadmin4;
}
