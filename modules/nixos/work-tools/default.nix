{ options, pkgs, config, lib, inputs, ... }:

with lib;
with lib.ironman;
# with lib.internal;
let
  cfg = config.ironman.work-tools;
in
{
  options.ironman.work-tools = with types; {
    enable = mkBoolOpt false "Enable the Work Machine Tools";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      24800
    ];
  };
}
