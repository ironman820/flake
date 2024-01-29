{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.android;
in {
  options.ironman.android = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    ironman.user.extraGroups = ["adbusers"];
    programs.adb = enabled;
  };
}
