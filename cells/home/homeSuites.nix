{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs sops-nix;
  inherit (inputs.cells) mine;
  d = inputs.cells.de.homeProfiles;
  h = cell.homeProfiles // mine.homeProfiles;
  l = nixpkgs.lib // mine.lib // builtins;
  s = inputs.cells.ssh.homeProfiles;
in rec {
  base = with h; [
    sops
    vars
    s.auth-keys
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
      h.dunst
      d.hyprland
      s.config
    ]
  ];
}
