{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.firmware;
in {
  options.mine.firmware = {
    enable = mkEnableOption "Enable or disable firmware support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firmware-manager
      gnome-firmware
    ];
    services.fwupd = enabled;
  };
}
