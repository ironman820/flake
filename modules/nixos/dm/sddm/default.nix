{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.dm.sddm;
in {
  options.mine.dm.sddm = {
    enable = mkEnableOption "Enable SDDM";
    wayland = mkBoolOpt true "Enable Wayland support";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [(
        pkgs.catppuccin-sddm.override {
          flavor = "mocha";
        }
      )];
    };
    services = {
      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        theme = "catppuccin-mocha";
        wayland.enable = cfg.wayland;
      };
    };
  };
}
