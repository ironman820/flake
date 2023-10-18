{ config, lib, pkgs, ...}:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.ironman.home.virtual.podman;
in
{
    options.ironman.home.virtual.podman = {
        enable = mkEnableOption "Enable podman aliases";
    };

  config.home.shellAliases = mkIf cfg.enable {
    "pdi" = "podman images";
    "pdo" = "podman images | awk '{print \$3,\$2}' | grep '<none>' | awk '{print \$1}' | xargs -t podman rmi";
    "pdr" = "podman rmi";
  };
}
