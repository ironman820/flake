{
  cell,
  inputs,
}: let
  inherit (inputs) stylix;
  boot = inputs.cells.boot.nixosProfiles;
in rec {
  workstation = [
    boot.grub
    # stylix.nixosModules.stylix
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
  ];
  laptop' = workstation; # ++ [
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
  # ];
}
