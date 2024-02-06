{
  lib,
  config,
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
    programs.adb = enabled;
  };
}
