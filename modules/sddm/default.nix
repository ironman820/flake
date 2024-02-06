{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.sddm;
in {
  options.mine.sddm = {enable = mkEnableOption "Enable SDDM";};

  config = mkIf cfg.enable {
    environment.systemPackages = [self.packages.${pkgs.system}.sddm-catppuccin];
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
