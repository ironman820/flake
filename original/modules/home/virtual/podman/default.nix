{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.virtual.podman;
  os = osConfig.mine.virtual.podman;
in {
  options.mine.home.virtual.podman = {
    enable = mkBoolOpt os.enable "Enable podman aliases";
  };

  config = mkIf cfg.enable {
    mine.home.tui.just = {
      apps = [
        "distrobox create -i ghcr.io/ironman820/ironman-ubuntu:22.04 -n ubuntu --home /home/${config.mine.home.user.name}/distrobox"
      ];
      updates = [
        "distrobox upgrade -a"
      ];
    };
    home = {
      shellAliases = {
        "pdi" = "podman images";
        "pdo" = "podman images | awk '{print \$3,\$2}' | grep '<none>' | awk '{print \$1}' | xargs -t podman rmi";
        "pdr" = "podman rmi";
      };
    };
  };
}
