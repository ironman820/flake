{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.sddm;
in
{
  options.ironman.sddm = {
    enable = mkEnableOption "Enable SDDM";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.ironman.tokyo-night-sddm
    ];
    services.xserver = {
      displayManager.sddm = {
        enable = true;
        theme = "tokyo-night-sddm";
      };
      enable = true;
    };
  };
}
