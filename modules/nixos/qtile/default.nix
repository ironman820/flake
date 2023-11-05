{ config, lib, pkgs, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.qtile;
in {
  options.ironman.qtile = {
    enable = mkEnableOption "Set up qtile window manager";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rofi
    ];
    services.xserver.windowManager.qtile = {
      # backend = "wayland";
      enable = true;
      extraPackages = py: with py; [
        qtile-extras
      ];
    };
  };
}
