{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.android;
in {
  options.mine.home.android = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      android-studio
      open-android-backup
    ];
  };
}
# whiptail secure-delete

