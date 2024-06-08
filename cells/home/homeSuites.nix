{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs sops-nix;
  inherit (inputs.cells) mine;
  h = cell.homeProfiles // mine.homeProfiles;
  l = nixpkgs.lib // mine.lib // builtins;
  ssh = inputs.cells.homeProfiles;
in rec {
  base = with h; [
    sops
    # hypridle.homeManagerModules.hypridle
    # hyprlock.homeManagerModules.hyprlock
    # impermanence.nixosModules.home-manager.impermanence
    vars
    ssh.auth-keys
    sops-nix.homeManagerModules.sops
    # stylix.homeManagerModules.stylix
    {home.stateVersion = "23.05";}
  ];
  laptop' = l.concatLists [
    workstation
    (with h; [
      bluetooth
      neomutt
    ])
  ];
  workstation = l.concatLists [
    base
    [
      ssh.config
    ]
  ];
}
