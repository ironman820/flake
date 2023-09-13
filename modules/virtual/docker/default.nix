{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.virtual.docker;
in
{
  options.ironman.virtual.docker = with types; {
    enable = mkBoolOpt false "Enable Docker";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
    ironman.user.extraGroups = [
      "docker"
    ];
    virtualisation.docker = enabled;
  };
}
