{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.vpn;
in {
  options.mine.vpn = {
    enable = mkEnableOption "Enable or disable extra networking support";
  };

  config = mkIf cfg.enable {
    # Might be needed for OpenVPN
    boot.kernelModules = ["tun"];
  };
}
