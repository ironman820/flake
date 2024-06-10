{
  cell,
  inputs,
}: let
  inherit (cell) nixosProfiles;
  inherit (inputs) home-manager nixpkgs sops-nix stylix;
  inherit (inputs.cells) mine;
  boot = inputs.cells.boot.nixosProfiles;
  l = nixpkgs.lib // mine.lib // builtins;
  networking = inputs.cells.networking.nixosProfiles;
  ssh = inputs.cells.ssh.nixosProfiles;
in rec {
  base = [
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
    mine.nixosProfiles.vars
    networking.dhcp
    {
      nix.settings = {
        substituters = [
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    }
    nixosProfiles.sops
    # nixosProfiles.stylix
    ssh.server
    sops-nix.nixosModules.sops
    # stylix.nixosModules.stylix
    {system.stateVersion = "23.05";}
  ];
  laptop' = l.concatLists [
    workstation
    # [
    #   hardware = {
    #     bluetooth = enabled;
    #     intel-video = enabled;
    #     power = enabled;
    #   };
    #   firmware = enabled;
    #   networking.profiles = enabled;
    #   services = {
    #     logind = {
    #       killUserProcesses = true;
    #       lidSwitchExternalPower = "ignore";
    #     };
    #     xserver.libinput = {
    #       enable = true;
    #       touchpad.naturalScrolling = true;
    #     };
    #   };
    #   ]
  ];
  server = l.concatLists [
    base
    [
      boot.systemd
      nixosProfiles.ld-cc
      nixosProfiles.power-performance
      nixosProfiles.sudo-no-password
      ssh.server-pass-auth
    ]
  ];
  workstation = l.concatLists [
    base
    [
      boot.grub
      networking.networkmanager
      # de.hyprland
      #   gui-apps = {
      #     alacritty = mkIf (terminal == "alacritty") enabled;
      #     contour = mkIf (terminal == "contour") enabled;
      #     floorp = mkIf (browser == "floorp") enabled;
      #     kitty = mkIf (terminal == "kitty") enabled;
      #     others = enabled;
      #     wezterm = mkIf (terminal == "wezterm") enabled;
      #     winbox = enabled;
      #   };
      #   hardware = {
      #     sound = enabled;
      #     yubikey = enabled;
      #   };
      #   libraries.java = enabled;
      #   networking.basic.networkmanager = enabled;
      #   servers.sync = enabled;
      #   tui = {
      #     flatpak = enabled;
      #     neomutt = enabled;
      #   };
      #   virtual.host = enabled;
      #   xdg = enabled;
      # boot.kernel.sysctl = {
      #   "vm.overcommit_memory" = 1;
      # };
      # environment.systemPackages = with pkgs; [
      #   hplip
      #   ntfs3g
      #   wireguard-tools
      # ];
      # programs.system-config-printer = enabled;
      # services = {
      #   avahi = enabled;
      #   printing = {
      #     enable = true;
      #     cups-pdf = enabled;
      #     drivers = with pkgs; [gutenprint hplip];
      #   };
      # };
    ]
  ];
}
