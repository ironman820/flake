{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine.user.settings.applications) browser terminal;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.suites.workstation;
in {
  options.mine.suites.workstation = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine = {
      boot.grub = enabled;
      de.hyprland = enabled;
      gui-apps = {
        alacritty = mkIf (terminal == "alacritty") enabled;
        contour = mkIf (terminal == "contour") enabled;
        floorp = mkIf (browser == "floorp") enabled;
        kitty = mkIf (terminal == "kitty") enabled;
        others = enabled;
        wezterm = mkIf (terminal == "wezterm") enabled;
        winbox = enabled;
      };
      hardware = {
        sound = enabled;
        yubikey = enabled;
      };
      libraries.java = enabled;
      networking.basic.networkmanager = enabled;
      sops = enabled;
      servers.sync = enabled;
      tui = {
        flatpak = enabled;
        neomutt = enabled;
      };
      virtual.host = enabled;
      xdg = enabled;
    };
    boot.kernel.sysctl = {
      "vm.overcommit_memory" = 1;
    };
    environment.systemPackages = with pkgs; [
      hplip
      ntfs3g
      wireguard-tools
    ];
    programs.system-config-printer = enabled;
    services = {
      avahi = enabled;
      printing = {
        enable = true;
        cups-pdf = enabled;
        drivers = with pkgs; [gutenprint hplip];
      };
    };
  };
}
