{ flakeRoot, ... }: {
  flake.nixosModules.drive-shares = { config, lib, ... }: {
    options.ironman.shares =
    let
      inherit (lib) mkEnableOption;
    in {
      personal = mkEnableOption "Personal shares";
      work = mkEnableOption "Work Shares";
    };
    config =
    let
      inherit (config.ironman) shares;
      inherit (lib) mkMerge mkIf;
    in
    {
      ironman.drive-shares = mkMerge [
        (mkIf shares.personal [
          "/mnt/nas ${config.sops.secrets.home-nas.path} --timeout 60 --browse"
        ])
        (mkIf shares.work [
          "/mnt/fileserver file:${config.sops.secrets.fileserver.path} --browse"
          # "/mnt/royell-ftp file:${config.sops.secrets.royell_ftp.path} --browse"
        ])
      ];
      programs.fuse.enable = true;
      services = {
        autofs = {
          enable = true;
          timeout = 60;
        };
        gvfs.enable = true;
      };
      sops.secrets =
      let
        workSops = flakeRoot + "/.secrets/drive-shares-work.yaml";
      in {
        fileserver = mkIf shares.work {
          sopsFile = workSops;
        };
        home-nas = mkIf shares.personal {
          sopsFile = flakeRoot + "/.secrets/drive-shares-personal.yaml";
        };
        royell_ftp = mkIf shares.work {
          sopsFile = workSops;
        };
      };
    };
  };
}
