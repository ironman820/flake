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
    bat
    default-home
    just
    git
    gpg
    man
    nvim
    sops
    ssh-auth-keys
    ssh-config
    tmux
    vars
    yazi
    sops-nix.homeManagerModules.sops
  ];
  laptop = l.concatLists [
    workstation
    (with h; [
      bluetooth
      neomutt
      imapfilter
    ])
  ];
  rcm = l.concatLists [
    server
    [
      {
        programs.git.extraConfig.safe.directory = "/data/rcm";
      }
    ]
  ];
  server = l.concatLists [
    base
    [
      h.server-sops
    ]
  ];
  workstation = l.concatLists [
    base
    (with h; [
      dwm
      flatpak
      kitty
      dunst
      others
      rofi
      swappy
      syncthing
      video-tools
      virtual-host
      wlogout
      yubikey
      {xdg = l.enabled;}
    ])
  ];
}
