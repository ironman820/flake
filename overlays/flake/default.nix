{
  inputs,
  system,
  ...
}: final: prev: {
  inherit (inputs.flake.packages.${system}) flake;
}
