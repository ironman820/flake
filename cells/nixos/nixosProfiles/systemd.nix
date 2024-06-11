{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  boot = {
    loader = {
      grub = l.disabled;
      systemd-boot = l.enabled;
    };
    plymouth = l.disabled;
  };
}
