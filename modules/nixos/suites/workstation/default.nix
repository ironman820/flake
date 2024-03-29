{
  config,
  lib,
  pkgs,
  ...
}: let
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
      java = enabled;
      networking.networkmanager = enabled;
      hyprland = enabled;
      sops = enabled;
      sound = enabled;
      sync = enabled;
      virtual.host = enabled;
      winbox = enabled;
      xdg = enabled;
      yubikey = enabled;
    };
    environment.systemPackages = with pkgs; [hplip ntfs3g];
    programs.system-config-printer = enabled;
    services = {
      avahi = enabled;
      flatpak = enabled;
      printing = {
        enable = true;
        cups-pdf = enabled;
        drivers = with pkgs; [gutenprint hplip];
      };
    };
  };
}
