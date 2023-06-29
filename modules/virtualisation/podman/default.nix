{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.virtualisation.podman;
in {
  options.ironman.virtualisation.podman = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
    compose = mkBoolOpt false "Whether to install podman-compose.";
  };

  config = mkIf cfg.enable {
    virtualisation.podman = enabled;
    environment = mkIf cfg.compose {
      systemPackages = [ pkgs.podman-compose ];
    };
  };
}