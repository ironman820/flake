{ options, pkgs, config, lib, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.ironman.configurations.work-samba;
in
{
  options.ironman.configurations.work-samba = {
    enable = mkEnableOption "Enable the Work SAMBA connections";
  };

  config = mkIf cfg.enable {
    ironman.sops.secrets = {
      fileserver = {
        sopsFile = ./secrets/fileserver.yaml;
      };
      # backup-server = {
      #   sopsFile = ./secrets/fileserver.yaml;
      # };
    };
    services.autofs = {
      enable = true;
      autoMaster = ''
        /run/media/${config.ironman.user.name}/fileserver ${config.sops.secrets.fileserver.path} --timeout 60 --browse
        # /run/media/${config.ironman.user.name}/backup-server ${config.sops.secrets.backup-server.path} --timeout 60 --browse
      '';
    };
  };
}

