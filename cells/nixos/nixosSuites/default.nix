{
  cell,
  inputs,
}: let
  inherit (inputs) home-manager nix-ld nixos-hardware nixpkgs sops-nix;
  inherit (inputs.cells) mine;
  h = nixos-hardware.nixosModules;
  l = nixpkgs.lib // mine.lib // builtins;
  p = cell.nixosProfiles;
in rec {
  base = with p; [
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
    vars
    dhcp
    nix-ld.nixosModules.nix-ld
    git
    sops
    python
    nix
    nvim
    ssh-server
    sops-nix.nixosModules.sops
    tmux
    {system.stateVersion = "23.05";}
  ];
  dns = l.concatLists [
    server
    (with p; [
      pdns
      pdns-recursor
    ])
    {
      environment.systemPackages = with nixpkgs; [
        dig
      ];
    }
  ];
  gitlab = l.concatLists [
    server
    (with p; [
      gitlab
      {
        sops.secrets = {
          "gitlab/databasePass" = {
            group = config.users.groups.keys.name;
            mode = "0440";
            sopsFile = ./secrets/gitlab.yaml;
          };
          "gitlab/secrets/secret" = {
            group = config.users.groups.keys.name;
            mode = "0440";
            sopsFile = ./secrets/gitlab.yaml;
          };
          "gitlab/secrets/otp" = {
            group = config.users.groups.keys.name;
            mode = "0440";
            sopsFile = ./secrets/gitlab.yaml;
          };
          "gitlab/secrets/db" = {
            group = config.users.groups.keys.name;
            mode = "0440";
            sopsFile = ./secrets/gitlab.yaml;
          };
        };
        users.users.gitlab.extraGroups = [
          config.users.groups.keys.name
        ];
      }
    ])
  ];
  laptop' = l.concatLists [
    workstation
    (with p; [
      h.common-pc-laptop
      h.common-pc-laptop-acpi_call
      net-profiles
      bluetooth
      intel-video
      power
      firmware
      neomutt
      {
        services = {
          logind = {
            killUserProcesses = true;
            lidSwitchExternalPower = "ignore";
          };
          libinput = {
            enable = true;
            touchpad.naturalScrolling = true;
          };
        };
      }
    ])
  ];
  server = l.concatLists [
    base
    [
      p.systemd
      p.ld-cc
      p.power-performance
      p.sudo-no-password
      p.ssh-server-pass-auth
    ]
  ];
  virtual-workstation = l.concatLists [
    workstation
    [
      p.sudo-no-password
      p.virtual-guest
      {
        powerManagement.cpuFreqGovernor = "performance";
      }
    ]
  ];
  workstation = l.concatLists [
    base
    [
      p.dunst
      p.flatpak
      p.floorp
      p.gpg
      p.grub
      p.hyprland
      p.java
      p.kitty
      p.networkmanager
      p.others
      p.printing
      p.sddm
      p.sound
      p.syncthing
      p.thunar
      p.virtual-host
      p.winbox
      p.workstation
      p.xdg
      p.yubikey
      {
        boot.kernel.sysctl = {
          "vm.overcommit_memory" = 1;
        };
      }
    ]
  ];
}
