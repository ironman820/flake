{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.virtual.podman;
in {
  options.mine.virtual.podman = {
    enable = mkEnableOption "Enable Podman";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      distrobox
      podman-compose
    ];
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket = enabled;
    };
  };
}
