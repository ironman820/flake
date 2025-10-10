{
  flake.nixosModules.drive-shares-personal =
    { config, flakeRoot, ... }:
    {
      ironman.drive-shares = [
        "/mnt/nas ${config.sops.secrets.home-nas.path} --timeout 60 --browse"
      ];
      sops.secrets.home-nas = {
        sopsFile = flakeRoot + "/.secrets/drive-shares-personal.yaml";
      };
    };
}
