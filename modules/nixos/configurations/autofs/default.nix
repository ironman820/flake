{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.ironman.configurations.autofs;
  sopsFile = ./secrets/shares.yaml;
in {
  options.ironman.configurations.autofs = {
    enable = mkEnableOption "Enable the Work SAMBA connections";
  };

  config = mkIf cfg.enable {
    ironman.sops.secrets = {
      fileserver = { inherit sopsFile; };
      royell_ftp = { inherit sopsFile; };
    };
    environment.systemPackages = with pkgs; [
      curlftpfs
    ];
    services.autofs = {
      enable = true;
      autoMaster = ''
        /run/media/${config.ironman.user.name}/fileserver ${config.sops.secrets.fileserver.path} --timeout 60 --browse
        /run/media/${config.ironman.user.name}/royell-ftp ${config.sops.secrets.royell_ftp.path} --timeout 60 --browse
      '';
      # /run/media/${config.ironman.user.name}/backup-server ${config.sops.secrets.backup-server.path} --timeout 60 --browse
    };
  };
}

