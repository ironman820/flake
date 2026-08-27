{ inputs, moduleWithSystem, ... }:
{
  flake.nixosModules.rcm2 = moduleWithSystem (
    perSystem@{ system, ... }:
    { pkgs, config, ... }:
    let
      phpPkgs = import inputs.nixpkgs-php {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      environment = {
        systemPackages = with pkgs; [
          nodejs
          unixODBC
          (unixODBCDrivers.msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
        ];
        unixODBCDrivers = with pkgs.unixODBCDrivers; [
          (msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
        ];
      };
      networking.firewall.enable = false;
      users.users.${config.ironman.user.name}.extraGroups = [
        config.services.nginx.group
      ];
    }
  );
}
