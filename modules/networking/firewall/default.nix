{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.networking.firewall;
in {
  options.ironman.networking.firewall = with types; {
    enable = mkBoolOpt true "Whether to setup the nix options or not.";
  };

  config = {
    networking = ifThenElse cfg.enable
      { nftables = enabled; }
      { firewall = disabled; };
  };
}