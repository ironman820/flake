{
  cell,
  inputs,
}: let
  inherit (inputs) home-manager nix-ld nixos-hardware nixpkgs quick-nix-registry sops-nix;
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
    default-nixos
    dhcp
    nix-ld.nixosModules.nix-ld
    git
    python
    ssh-config
    sops
    nix
    nvim
    quick-nix-registry.nixosModules.local-registry
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
  laptop = l.concatLists [
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
        environment.systemPackages = with nixpkgs; [
          zathura
        ];
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
    (with p; [
      dunst
      dwm
      flatpak
      gpg
      grub
      java
      kitty
      networkmanager
      others
      printing
      sddm
      sound
      syncthing
      thunar
      virtual-host
      winbox
      xdg
      yubikey
      {
        boot.kernel.sysctl = {
          "vm.overcommit_memory" = 1;
        };
        environment.systemPackages = with nixpkgs; [
          hplip
          ntfs3g
          wireguard-tools
        ];
      }
    ])
  ];
}
