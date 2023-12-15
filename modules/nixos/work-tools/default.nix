{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.work-tools;
  fw = config.ironman.networking.firewall;
in
{
  options.ironman.work-tools = {
    enable = mkEnableOption "Enable the Work Machine Tools";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf fw [
      24800
    ];
  };
}
