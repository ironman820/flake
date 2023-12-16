{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.work-tools;
in
{
  options.ironman.work-tools = {
    enable = mkEnableOption "Enable the Work Machine Tools";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.ironman.networking.firewall {
      allowedTCPPorts = [
        24800
      ];
    };
  };
}
