{config, ...}: let
  sopsFile = ./secrets/work.yml;
in {
  mine = {
    drives.autofs = {
      enable = true;
      shares = [
        "/run/media/${config.mine.user.name}/fileserver ${config.sops.secrets.fileserver.path} --timeout 60 --browse"
        "/run/media/${config.mine.user.name}/royell-ftp ${config.sops.secrets.royell_ftp.path} --timeout 60 --browse"
      ];
    };
    sops.secrets = {
      fileserver = {inherit sopsFile;};
      royell_ftp = {inherit sopsFile;};
    };
  };
}
