{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.boot.grub;
in {
  options.ironman.boot.grub = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot = {
      loader.grub = {
        efiSupport = true;
        device = "nodev";
        theme = "${pkgs.catppuccin-grub}/share/grub/themes/catppuccin-mocha-grub-theme";
      };
      plymouth = enabled;
    };
  };
}
