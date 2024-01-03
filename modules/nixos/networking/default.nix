{ config, lib, options, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf mkMerge;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) int listOf str;
  cfg = config.ironman.networking;
  nm = config.ironman.networking.networkmanager;
in {
  options.ironman.networking = {
    address = mkOpt str "" "IP Address";
    dhcp = mkBoolOpt true "Enable DHCP?";
    enable = mkBoolOpt true "Enable or disable extra networking support";
    enableIPv6 = mkBoolOpt true "Enable IPv6";
    firewall = mkEnableOption "Enable Firewall";
    gateway = mkOpt str "" "Default Gateway";
    interface = mkOpt str "" "Interface to configure";
    nameservers = mkOpt (listOf str) [ ] "Nameservers";
    network = mkOpt str "" "Network listing used for services.";
    prefix = mkOpt int 24 "Subnet Mask Prefix";
    networkmanager = {
      enable = mkEnableOption "Enable NetworkManager";
      applet = mkBoolOpt true "Enable networkmanager applet";
    };
  };

  config = mkIf cfg.enable {
    environment = mkIf (nm.enable && nm.applet) {
      systemPackages = mkMerge [
        [ pkgs.networkmanagerapplet ]
        (mkIf config.ironman.hyprland.enable [ pkgs.networkmanager_dmenu ])
        (mkIf config.ironman.qtile.enable [ pkgs.networkmanager_dmenu ])
      ];
    };
    ironman.user.extraGroups = mkIf nm.enable [ "networkmanager" ];
    networking = {
      inherit (cfg) enableIPv6;
      defaultGateway = mkIf (!cfg.dhcp) { address = cfg.gateway; };
      dhcpcd.enable = cfg.dhcp;
      firewall = mkMerge [
        { enable = cfg.firewall; }
        (mkIf cfg.firewall {
          allowedUDPPorts = [ 1900 ];
          checkReversePath = "loose";
        })
      ];
      interfaces = mkIf (builtins.stringLength cfg.interface > 0) {
        ${cfg.interface}.ipv4.addresses = [{
          inherit (cfg) address;
          prefixLength = cfg.prefix;
        }];
      };
      nameservers = mkAliasDefinitions options.ironman.networking.nameservers;
      networkmanager = mkIf nm.enable { inherit (nm) enable; };
      nftables.enable = cfg.firewall;
    };
  };
}
