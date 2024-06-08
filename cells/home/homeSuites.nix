{
  cell,
  inputs,
}: let
  inherit (cell) homeProfiles;
  inherit (inputs) nixpkgs sops-nix;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in rec {
  base = [
    homeProfiles.sops
    # hypridle.homeManagerModules.hypridle
    # hyprlock.homeManagerModules.hyprlock
    # impermanence.nixosModules.home-manager.impermanence
    sops-nix.homeManagerModules.sops
    # stylix.homeManagerModules.stylix
    {home.stateVersion = "23.05";}
  ];
}
