{
  cell,
  inputs,
}: let
  inherit (cell) nixosProfiles;
  inherit (inputs) nixpkgs sops-nix stylix;
  inherit (inputs.cells) mine;
  boot = inputs.cells.boot.nixosProfiles;
  l = nixpkgs.lib // mine.lib // builtins;
  networking = inputs.cells.networking.nixosProfiles;
  servers = inputs.cells.servers.nixosProfiles;
in rec {
  base = [
    mine.nixosProfiles.vars
    networking.dhcp
    nixosProfiles.sops
    # nixosProfiles.stylix
    servers.ssh
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
      servers.ssh-pass-auth
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
      #   sops = enabled;
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
