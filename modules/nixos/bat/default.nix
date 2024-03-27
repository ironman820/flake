{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt;
  cfg = config.mine.bat;
in {
  options.mine.bat = {
    enable = mkBoolOpt true "Enable bat installation";
    batman = mkEnableOption "Enable batman pager alias";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      (with pkgs; [
        bat
        delta
        entr
      ])
      ++ (with pkgs.bat-extras; [
        batdiff
        batgrep
        batman
        batpipe
        batwatch
        prettybat
      ]);
  };
}
