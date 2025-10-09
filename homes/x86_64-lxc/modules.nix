{inputs, ...}: {
  imports = with inputs; [
    sops-nix.homeManagerModules.sops
    stylix.homeModules.stylix
  ];
}
