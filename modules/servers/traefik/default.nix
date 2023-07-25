{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.traefik;
in
{
  options.ironman.servers.traefik = {
    enable = mkBoolOpt false "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
  };
}
