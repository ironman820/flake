{
  cell,
  inputs,
}: let
  inherit (cell) homeProfiles;
  inherit (inputs) nixpkgs sops-nix;
  inherit (inputs.cells) mine;
  h = mine.homeProfiles;
  l = nixpkgs.lib // mine.lib // builtins;
  ssh = inputs.cells.ssh.homeProfiles;
in rec {
  base = [
    homeProfiles.sops
    # hypridle.homeManagerModules.hypridle
    # hyprlock.homeManagerModules.hyprlock
    # impermanence.nixosModules.home-manager.impermanence
    mine.homeProfiles.vars
    ssh.auth-keys
    sops-nix.homeManagerModules.sops
    # stylix.homeManagerModules.stylix
    {home.stateVersion = "23.05";}
  ];
  laptop' = l.concatLists [
    workstation
    [
      h.bluetooth
      homeProfiles.neomutt
    ]
  ];
  workstation = l.concatLists [
    base
    [
      ssh.config
    ]
  ];
}
