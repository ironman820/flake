{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs sops-nix;
  inherit (inputs.cells) mine;
  h = cell.homeProfiles;
  l = nixpkgs.lib // mine.lib // builtins;
in rec {
  base = with h; [
    sops
    h.ssh-auth-keys
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
    (with h; [
      floorp
      kitty
      dunst
      rofi
      video-tools
      yubikey
      hyprland
      wlogout
      ssh-config
      syncthing
      waybar
      virtual-host
      {xdg = l.enabled;}
    ])
  ];
}
