{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.servers.pixiecore;
in {
  options.mine.servers.pixiecore = {
    enable = mkEnableOption "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    services.pixiecore = {
      dhcpNoBind = true;
      enable = true;
      mode = "quick";
      openFirewall = true;
    };
  };
}
