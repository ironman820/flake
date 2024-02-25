{inputs, ...}: {
  imports = with inputs; [
    hypridle.homeManagerModules.hypridle
    hyprlock.homeManagerModules.hyprlock
    sops-nix.homeManagerModules.sops
    stylix.homeManagerModules.stylix
  ];
}
