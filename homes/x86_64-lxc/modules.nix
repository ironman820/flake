{inputs, ...}: {
  imports = with inputs; [
    hypridle.homeManagerModules.hypridle
    hyprlock.homeManagerModules.hyprlock
    impermanence.nixosModules.home-manager.impermanence
    sops-nix.homeManagerModules.sops
    stylix.homeManagerModules.stylix
  ];
}
