{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.virtualisation.distrobox;
in {
  options.ironman.virtualisation.distrobox = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.distrobox ];
    ironman.virtualisation.podman = enabled;
  };
}