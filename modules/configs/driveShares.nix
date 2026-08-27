{
  self,
  ...
}:
{
  flake.nixosModules.driveShares =
    {
      config,
      lib,
      ...
    }:
    {
      options.ironman =
        let
          inherit (lib) mkEnableOption mkOption types;
        in
        {
          drive-shares = mkOption {
            type = types.lines;
            default = "";
            description = "AutoFS autoMaster share declarations";
          };
          shares = {
            personal = mkEnableOption "Personal shares";
            work = mkEnableOption "Work Shares";
          };
        };
      config =
        let
          inherit (lib) concatStringsSep mkIf;
          inherit (config.ironman) drive-shares shares;
          sps = config.sops.secrets;
        in
        {
          ironman.drive-shares = concatStringsSep "\n" [
            (if shares.personal then "/mnt/nas ${sps.home-nas.path} --timeout 60 --browse" else "")
            (if shares.work then "/mnt/fileserver file:${sps.fileserver.path} --browse" else "")
          ];
          programs.fuse.enable = true;
          services = {
            autofs = {
              enable = true;
              autoMaster = drive-shares;
              timeout = 60;
            };
            gvfs.enable = true;
          };
          sops.secrets =
            let
              workSops = "${self.outPath}/.secrets/drive-shares-work.yaml";
            in
            {
              fileserver = mkIf shares.work {
                sopsFile = workSops;
              };
              home-nas = mkIf shares.personal {
                sopsFile = "${self.outPath}/.secrets/drive-shares-personal.yaml";
              };
            };
        };
    };
}
