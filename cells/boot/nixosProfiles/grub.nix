{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  inherit (inputs.cells.grub-cyberexs.packages) grub-cyberexs;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  boot = {
    loader.grub = {
      efiSupport = true;
      device = "nodev";
      theme = "${grub-cyberexs}/share/grub/themes/CyberEXS";
    };
    plymouth = l.enabled;
  };
  # stylix.targets = {
  #   grub = l.disabled;
  #   plymouth = l.disabled;
  # };
}
