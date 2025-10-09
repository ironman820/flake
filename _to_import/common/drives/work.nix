{config, ...}: let
  sopsFile = ./secrets/work.yml;
in {
  mine = {
    networking.drives.autofs = {
      enable = true;
      shares = [
        "/mnt/fileserver ${config.sops.secrets.fileserver.path} --timeout 60 --browse"
        "/mnt/royell-ftp ${config.sops.secrets.royell_ftp.path} --timeout 60 --browse"
      ];
    };
    sops.secrets = {
      fileserver = {inherit sopsFile;};
      royell_ftp = {inherit sopsFile;};
    };
  };
}
