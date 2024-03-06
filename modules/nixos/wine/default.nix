{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.wine;
in {
  options.mine.wine = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages =
      (with pkgs; [
        q4wine
        winetricks
      ])
      ++ (with pkgs.wineWowPackages; [
        full
        waylandFull
      ]);
  };
}
