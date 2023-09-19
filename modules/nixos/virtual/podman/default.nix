{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.virtual.podman;
in
{
  options.ironman.virtual.podman = with types; {
    enable = mkBoolOpt false "Enable Podman";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = (with pkgs; [
      distrobox
      podman-compose
    ]);
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket = enabled;
    };
  };
}
