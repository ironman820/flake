{
  flake.nixosModules.ironman =
    {
      config,
      lib,
      options,
      ...
    }:
    with lib;
    {
      options.ironman = {
        user = {
          name = mkOption {
            type = types.str;
            default = "ironman";
            description = "User name to pass to other functions";
          };
          fullName = mkOption {
            type = types.str;
            default = "Nicholas Eastman";
            description = "The user's full name";
          };
          email = {
            bob = mkOption {
              type = types.str;
              default = "!!USER@DOMAIN!!";
              description = "The user's email address";
            };
            site = mkOption {
              type = types.str;
              default = "";
              description = "email domain";
            };
          };
        };
        drive-shares = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "AutoFS autoMaster share declarations";
        };
      };
      config =
        let
          inherit (config.ironman.user) name;
        in
        {
          ironman.user.email = {
            bob = lib.mkDefault "nicholas.m.eastman";
            site = lib.mkDefault "gmail.com";
          };
          services.autofs.autoMaster = strings.concatStringsSep "\n" (
            lists.flatten (mkAliasDefinitions options.ironman.drive-shares).content.contents
          );
          users.groups.${name} = { };
          users.users.${name} = {
            group = name;
            isNormalUser = true;
          };
        };
    };
}
