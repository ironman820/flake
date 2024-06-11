{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) grub-cyberexs mine;
  l = nixpkgs.lib // mine.lib // builtins;
  p = grub-cyberexs.packages;
in {
  boot = {
    loader.grub = {
      efiSupport = true;
      device = "nodev";
      theme = "${p.grub-cyberexs}/share/grub/themes/CyberEXS";
    };
    plymouth = l.enabled;
  };
  # stylix.targets = {
  #   grub = l.disabled;
  #   plymouth = l.disabled;
  # };
}
