{ config, inputs, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.sddm;
in {
  options.ironman.sddm = { enable = mkEnableOption "Enable SDDM"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ sddm-catppuccin ];
    services.xserver = {
      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        theme = "catppuccin-mocha";
      };
      enable = true;
    };
  };
}
