{config, ...}: let
  sopsFile = ./secrets/personal.yml;
in {
  mine = {
    drives.autofs = {
      enable = true;
      shares = [
        "/run/media/${config.mine.user.name}/home-nas ${config.sops.secrets.home-nas.path} --timeout 60 --browse"
      ];
    };
    sops.secrets = {
      home-nas = {inherit sopsFile;};
    };
  };
}
