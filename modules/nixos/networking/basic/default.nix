{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.networking.basic;
  nm = config.mine.networking.basic.networkmanager;
in {
  options.mine.networking.basic = {
    enable = mkBoolOpt true "Enable or disable extra networking support";
    firewall = mkEnableOption "Enable Firewall";
    networkmanager = {
      enable = mkEnableOption "Enable NetworkManager";
      applet = mkBoolOpt true "Enable networkmanager applet";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = mkIf (nm.enable && nm.applet) (mkMerge [
        [pkgs.networkmanagerapplet]
        (mkIf config.mine.de.hyprland.enable [pkgs.networkmanager_dmenu])
        (mkIf config.mine.de.qtile.enable [pkgs.networkmanager_dmenu])
      ]);
    };
    mine.user.extraGroups = mkIf nm.enable ["networkmanager"];
    networking = {
      firewall = mkMerge [
        {enable = cfg.firewall;}
        (mkIf cfg.firewall {
          allowedUDPPorts = [1900];
          checkReversePath = "loose";
        })
      ];
      networkmanager = mkIf nm.enable {inherit (nm) enable;};
      nftables.enable = cfg.firewall;
    };
  };
}
