{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  networking = {
    dhcpcd = l.disabled;
  };
}
