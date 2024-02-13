{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.configurations.autofs;
  sopsFile = ./secrets/shares.yaml;
in {
  options.mine.configurations.autofs = {
    enable = mkEnableOption "Enable the Work SAMBA connections";
  };

  config = mkIf cfg.enable {
    mine.sops.secrets = {
      fileserver = {inherit sopsFile;};
      royell_ftp = {inherit sopsFile;};
    };
    environment.systemPackages = with pkgs; [
      curlftpfs
    ];
    services.autofs = {
      enable = true;
      autoMaster = ''
        /run/media/${config.mine.user.name}/fileserver ${config.sops.secrets.fileserver.path} --timeout 60 --browse
        /run/media/${config.mine.user.name}/royell-ftp ${config.sops.secrets.royell_ftp.path} --timeout 60 --browse
      '';
      # /run/media/${config.mine.user.name}/backup-server ${config.sops.secrets.backup-server.path} --timeout 60 --browse
    };
  };
}
