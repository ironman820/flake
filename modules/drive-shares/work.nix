{
  flake.nixosModules.drive-shares-work =
    { config, flakeRoot, ... }:
    let
      sopsFile = flakeRoot + "/.secrets/drive-shares-work.yaml";
    in
    {
      ironman.drive-shares = [
          "/mnt/fileserver file:${config.sops.secrets.fileserver.path} --browse"
          # "/mnt/royell-ftp file:${config.sops.secrets.royell_ftp.path} --browse"
        ];
      sops.secrets = {
        fileserver = { inherit sopsFile; };
        royell_ftp = { inherit sopsFile; };
      };
    };
}
