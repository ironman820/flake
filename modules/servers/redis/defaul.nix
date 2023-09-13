{ config, lib, pkgs, system, ... }:
with lib;
let
  cfg = config.ironman.servers.redis;
in
{
  options.ironmna.servers.redis = {
    enable = mkBoolOpt false "Install and enable Redis";
  };

  config = mkIf cfg.enable {
    services.redis."" = enabled;
  };
}
