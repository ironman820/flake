{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.ironman.networking.wireless;
  hash = "sha256:0x18qkwxfzmhbn6cn2da0xn27mxnmiw56qwx3kjvy9ljcar5czvh";
in {
  imports = [
    (import (builtins.fetchTarball {
      url = "https://github.com/jmackie/nixos-networkmanager-profiles/archive/master.tar.gz";
      sha256 = hash;
    }))
  ];

  options.ironman.networking.wireless = {
    enable = mkBoolOpt false "Enable Wireless settings.";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.profiles = {
      "DumbledoresArmy" = {
        connection = {
          type = "wifi";
          permissions = "";
          id = "DumbledoresArmy";
          uuid = "9725c49f-5808-4663-8d9f-d8d7bd38cf7d";
        };
        wifi = {
          mac-address-blacklist = "";
          mode = "infrastructure";
          ssid = "DumbledoresArmy";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "Alohomora";
        };
        ipv4 = {
          dns-search = "";
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "stable-privacy";
          dns-search = "";
          method = "auto";
        };
      };
    };
  };
}