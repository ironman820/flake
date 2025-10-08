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
      tui = {
        flatpak = enabled;
      };
      virtual = {
        host = enabled;
        podman = enabled;
      };
      xdg = enabled;
    };
    boot.kernel.sysctl = {
      "vm.overcommit_memory" = 1;
    };
    environment.systemPackages = with pkgs; [
      # bottles
      hplip
      ntfs3g
      obsidian
      wireguard-tools
      zed-editor
    ];
    programs = {
      steam = enabled;
      system-config-printer = enabled;
    };
    services = {
      avahi = enabled;
      printing = {
        enable = true;
        cups-pdf = enabled;
        drivers = with pkgs; [gutenprint hplip];
      };
      udisks2 = enabled;
    };
  };
}
