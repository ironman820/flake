{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.copyparty = moduleWithSystem (
      perSystem@{ ... }:
      { config, ... }: {
        imports = [
          inputs.copyparty.nixosModules.default
        ];
        services.copyparty = {
          enable = true;
          user = config.ironman.user.name;
          group = config.ironman.user.name;
          settings = {
            i = "0.0.0.0";
            z = true;
          };
          accounts.ironman.passwordFile = config.sops.secrets.ironman_password.path;
          volumes = {
            "/" = {
              path = "/shares";
              access = {
                r = "*";
                "rw." = [
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
      }
    );
    homeModules.copyparty = moduleWithSystem (
      perSystem@{ ... }:
      _: {
      }
    );
  };
}
