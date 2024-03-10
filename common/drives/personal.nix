{
  config,
  pkgs,
  ...
}: {
  mine = {
    drives.autofs = {
      enable = true;
      shares = [
        "/mnt/nas ${config.sops.secrets.home-nas.path} --timeout 60 --browse"
      ];
    };
    sops.secrets = {
      home-nas = {
        sopsFile = ./secrets/personal.yml;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    cifs-utils
    enum4linux
  ];
}
