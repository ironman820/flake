{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.copyparty = { config, ... }: {
    imports = [
      inputs.copyparty.nixosModules.default
    ];
    services.copyparty = {
      enable = true;
      user = config.ironman.user.name;
      group = config.ironman.user.name;
      settings = {
        i = "0.0.0.0";
        rproxy = -1;
        xf-proto = "X-Forwarded-Proto";
        xf-host = "storage.home.niceastman.com";
        xff-src = "lan";
        z = true;
      };
      accounts.ironman.passwordFile = config.sops.secrets.ironman_password.path;
      volumes = {
        "/" = {
          path = "/shares";
          access = {
            r = "*";
            "A" = [
              "ironman"
            ];
          };
          flags = {
            fk = 4;
            scan = 60;
            e2d = true;
          };
        };
      };
    };
    sops.secrets.ironman_password = {
      sopsFile = "${self.outPath}/.secrets/ironman.yaml";
      owner = config.ironman.user.name;
      group = config.ironman.user.name;
    };
  };
}
