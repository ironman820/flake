{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.servers.resilio;
in {
  options.mine.servers.resilio = {
    enable = mkEnableOption "resilio";
  };

  config = mkIf cfg.enable {
    services.resilio = {
      enable = true;
      checkForUpdates = false;
      enableWebUI = true;
    };
  };
}
