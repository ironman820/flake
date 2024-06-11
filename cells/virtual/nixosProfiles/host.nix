{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  v = config.vars;
in {
  users.users.${v.username}.extraGroups = [
    "libvirtd"
  ];
  programs.virt-manager = l.enabled;
  virtualisation.libvirtd = l.enabled;
}
