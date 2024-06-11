{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.virtual.docker;
in {
  options.mine.virtual.docker = {
    enable = mkEnableOption "Enable Docker";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
    mine.user.extraGroups = [
      "docker"
    ];
    virtualisation.docker = enabled;
  };
}
