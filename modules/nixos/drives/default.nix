{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.drives;
  sopsFile = ./secrets/shares.yaml;
in {
  options.mine.drives = {
    enable = mkBoolOpt true "Load drivers for drives and media";
    autofs = {
      enable = mkEnableOption "Enable the Work SAMBA connections";
    };
  };

  config = mkIf cfg.enable {
    mine.sops.secrets = mkIf cfg.autofs.enable {
      fileserver = {inherit sopsFile;};
      royell_ftp = {inherit sopsFile;};
    };
    environment.systemPackages = with pkgs; [
      curlftpfs
      fuse
    ];
    services.autofs = mkIf cfg.autofs.enable {
      inherit (cfg.autofs) enable;
      autoMaster = ''
        /run/media/${config.mine.user.name}/fileserver ${config.sops.secrets.fileserver.path} --timeout 60 --browse
        /run/media/${config.mine.user.name}/royell-ftp ${config.sops.secrets.royell_ftp.path} --timeout 60 --browse
      '';
    };
  };
}
