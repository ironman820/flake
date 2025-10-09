{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.servers.redis;
in {
  options.mine.servers.redis = {
    enable = mkEnableOption "Install and enable Redis";
  };

  config = mkIf cfg.enable {
    services.redis.servers."".enable = true;
  };
}
