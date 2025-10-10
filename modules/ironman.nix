{
  flake.nixosModules.ironman =
    { config, lib, options, ... }:
    with lib;
    {
      options.ironman = {
        user = mkOption {
          type = types.str;
          default = "ironman";
          description = "User name to pass to other functions";
        };
        drive-shares = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "AutoFS autoMaster share declarations";
        };
      };
      config =
        let
          inherit (config.ironman) user;
        in
        {
          services.autofs.autoMaster = strings.concatStringsSep "\n" (
            lists.flatten (mkAliasDefinitions options.ironman.drive-shares).content.contents
          );
          users.groups.${user} = { };
          users.users.${user} = {
            group = user;
            isNormalUser = true;
          };
        };
    };
}
