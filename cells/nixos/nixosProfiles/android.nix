{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.android;
in {
  options.mine.android = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.user.extraGroups = ["adbusers"];
    environment.systemPackages = with pkgs; [
      android-studio
      open-android-backup
    ];
    programs.adb = enabled;
    services.udev.packages = [
      pkgs.android-udev-rules
    ];
  };
}
