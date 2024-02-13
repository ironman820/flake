{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) disabled enabled mkBoolOpt;
  cfg = config.mine.boot.systemd;
in {
  options.mine.boot.systemd = {
    enable = mkBoolOpt (!config.mine.boot.grub.enable) "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        grub = disabled;
        systemd-boot = enabled;
      };
      plymouth = disabled;
    };
  };
}
