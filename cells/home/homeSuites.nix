{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs sops-nix;
  inherit (inputs.cells) mine;
  d = inputs.cells.de.homeProfiles;
  g = inputs.cells.gui-apps.homeProfiles;
  h = cell.homeProfiles // mine.homeProfiles;
  hw = inputs.cells.hardware.homeProfiles;
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
      g.floorp
      g.kitty
      h.dunst
      h.rofi
      hw.yubikey
      d.hyprland
      s.config
    ]
  ];
}
