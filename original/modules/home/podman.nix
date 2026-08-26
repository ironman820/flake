{
  flake.homeModules.podman = _: {
    ironman.just = {
      apps = [
        "distrobox create -i ghcr.io/ironman820/ironman-ubuntu:22.04 -n ubuntu"
      ];
      updates = [
        "distrobox upgrade -a"
      ];
    };
    home = {
      shellAliases = {
        "pdi" = "podman images";
        "pdo" =
          "podman images | awk '{print \$3,\$2}' | grep '<none>' | awk '{print \$1}' | xargs -t podman rmi";
        "pdr" = "podman rmi";
      };
    };
  };
}
