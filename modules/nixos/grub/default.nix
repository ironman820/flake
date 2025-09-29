{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled disabled;

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
        theme = "${pkgs.grub-cyberexs}/share/grub/themes/CyberEXS";
      };
      plymouth = enabled;
    };
    stylix.targets = {
      grub = disabled;
      plymouth = disabled;
    };
  };
}
