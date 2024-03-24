{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled disabled;

  cfg = config.mine.boot.grub;
  imp = config.mine.impermanence.enable;
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
    environment.persistence."/persist/root".directories = mkIf imp [
      "/var/lib/plymouth"
    ];
    stylix.targets = {
      grub = disabled;
      plymouth = disabled;
    };
  };
}
