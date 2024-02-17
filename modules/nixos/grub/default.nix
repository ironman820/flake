{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (lib.mine) enabled;
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
        theme = mkDefault "${pkgs.catppuccin-grub}/share/grub/themes/catppuccin-mocha-grub-theme";
      };
      plymouth = enabled;
    };
  };
}
