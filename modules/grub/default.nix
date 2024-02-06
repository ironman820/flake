{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  # inherit (lib.mine) enabled;
  inherit (lib.mine) disabled;
  cfg = config.mine.boot.grub;
in {
  options.mine.boot.grub = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot = {
      loader.grub = {
        efiSupport = true;
        device = "nodev";
        theme = "${pkgs.catppuccin-grub}/share/grub/themes/catppuccin-mocha-grub-theme";
      };
      # plymouth = enabled;
      plymouth = disabled;
    };
  };
}
