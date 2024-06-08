{
  cell,
  inputs,
}: let
  inherit (cell) homeProfiles;
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in rec {
  base = [
    # hypridle.homeManagerModules.hypridle
    # hyprlock.homeManagerModules.hyprlock
    # impermanence.nixosModules.home-manager.impermanence
    # sops-nix.homeManagerModules.sops
    # stylix.homeManagerModules.stylix
    {home.stateVersion = "23.05";}
  ];
}
