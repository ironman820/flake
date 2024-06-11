{
  cell,
  inputs,
}: let
  inherit (cell) nixosProfiles;
  inherit (inputs) home-manager nix-ld nixos-hardware nixpkgs sops-nix;
  inherit (inputs.cells) de gui-apps hardware libraries mine servers tui;
  boot = inputs.cells.boot.nixosProfiles;
  h = nixos-hardware.nixosModules;
  l = nixpkgs.lib // mine.lib // builtins;
  n = inputs.cells.networking.nixosProfiles;
  p = nixosProfiles // de.nixosProfiles // gui-apps.nixosProfiles // hardware.nixosProfiles // libraries.nixosProfiles // mine.nixosProfiles // servers.nixosProfiles // tui.nixosProfiles;
  s = inputs.cells.ssh.nixosProfiles;
  v = inputs.cells.virtual.nixosProfiles;
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
    n.dhcp
    nix-ld.nixosModules.nix-ld
    p.git
    p.just
    p.sops
    p.python
    p.nix
    s.server
    sops-nix.nixosModules.sops
    {system.stateVersion = "23.05";}
  ];
  laptop' = l.concatLists [
    workstation
    [
      h.common-pc-laptop
      h.common-pc-laptop-acpi_call
      n.profiles
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
      boot.systemd
      p.ld-cc
      p.power-performance
      p.sudo-no-password
      s.server-pass-auth
    ]
  ];
  workstation = l.concatLists [
    base
    [
      boot.grub
      n.networkmanager
      p.dunst
      p.floorp
      p.hyprland
      p.kitty
      p.others
      p.sddm
      p.winbox
      p.sound
      p.gpg
      p.yubikey
      p.java
      n.networkmanager
      p.sync
      p.flatpak
      v.host
      p.xdg
      p.printing
      p.workstation
      p.thunar
      {
        boot.kernel.sysctl = {
          "vm.overcommit_memory" = 1;
        };
      }
    ]
  ];
}
