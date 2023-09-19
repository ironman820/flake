{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.redis;
in
{
  options.ironman.servers.redis = with types; {
    enable = mkBoolOpt false "Install and enable Redis";
  };

  config = mkIf cfg.enable {
    services.redis.servers."".enable = true;
  };
}
