{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.podman;
in {
  options.mine.home.podman = {
    enable = mkEnableOption "Enable podman aliases";
  };

  config = mkIf cfg.enable {
    mine.home.just = {
      apps = [
        "distrobox create -i ghcr.io/ironman820/ironman-ubuntu:22.04 -n ubuntu --home /home/${config.mine.home.user.name}/distrobox"
      ];
      updates = [
        "distrobox upgrade -a"
      ];
    };
    home.shellAliases = {
      "pdi" = "podman images";
      "pdo" = "podman images | awk '{print \$3,\$2}' | grep '<none>' | awk '{print \$1}' | xargs -t podman rmi";
      "pdr" = "podman rmi";
    };
  };
}
