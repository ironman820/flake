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
  base = [
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
    p.vars
    p.dhcp
    nix-ld.nixosModules.nix-ld
    p.git
    p.just
    p.sops
    p.python
    p.nix
    p.ssh-server
    sops-nix.nixosModules.sops
    {system.stateVersion = "23.05";}
  ];
  laptop' = l.concatLists [
    workstation
    [
      h.common-pc-laptop
      h.common-pc-laptop-acpi_call
      p.net-profiles
      p.bluetooth
      p.intel-video
      p.power
      p.firmware
      p.neomutt
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
    ]
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
