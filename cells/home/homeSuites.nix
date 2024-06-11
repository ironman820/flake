{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs sops-nix;
  inherit (inputs.cells) de gui-apps hardware mine servers tui;
  g = inputs.cells.gui-apps.homeProfiles;
  h = cell.homeProfiles // de.homeProfiles // gui-apps.homeProfiles // hardware.homeProfiles // mine.homeProfiles // servers.homeProfiles // tui.homeProfiles;
  l = nixpkgs.lib // mine.lib // builtins;
  s = inputs.cells.ssh.homeProfiles;
  v = inputs.cells.virtual.homeProfiles;
in rec {
  base = with h; [
    sops
    s.auth-keys
    sops-nix.homeManagerModules.sops
    vars
    {
      home.stateVersion = "23.05";
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
      };
    }
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
      h.video-tools
      h.yubikey
      h.hyprland
      h.wlogout
      s.config
      h.sync
      h.waybar
      v.host
      {xdg = l.enabled;}
    ]
  ];
}
