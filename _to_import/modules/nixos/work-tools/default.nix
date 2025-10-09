{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.work-tools;
in {
  options.mine.work-tools = {
    enable = mkEnableOption "Enable the Work Machine Tools";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.mine.networking.basic.firewall {
      allowedTCPPorts = [
        24800
      ];
    };
  };
}
