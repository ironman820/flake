{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.networking.basic;
in {
  options.mine.networking.basic = {
    enable = mkBoolOpt true "Enable or disable extra networking support";
    firewall = mkEnableOption "Enable Firewall";
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = mkMerge [
        {enable = cfg.firewall;}
        (mkIf cfg.firewall {
          allowedUDPPorts = [1900];
          checkReversePath = "loose";
        })
      ];
      nftables.enable = cfg.firewall;
    };
  };
}
