{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  services = {
    qemuGuest = l.enabled;
    spice-vdagentd = l.enabled;
    spice-webdavd = l.enabled;
  };
}
