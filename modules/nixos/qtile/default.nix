{ config, lib, pkgs, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.qtile;
in {
  options.ironman.qtile = {
    enable = mkEnableOption "Set up qtile window manager";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bashmount
      feh
      rofi
    ];
    services = {
      udisks2 = enabled;
      xserver.windowManager.qtile = {
        enable = true;
        extraPackages = py: with py; [
          qtile-extras
        ];
      };
    };
  };
}
