{
  flake.nixosModules.ironman =
    {
      lib,
      options,
      ...
    }:
    with lib;
    {
      options.ironman = {
        drive-shares = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "AutoFS autoMaster share declarations";
        };
        personal_laptop = mkEnableOption "personal laptop";
        work_laptop = mkEnableOption "work laptop";
      };
      config = {
        services.autofs.autoMaster = strings.concatStringsSep "\n" (
          lists.flatten (mkAliasDefinitions options.ironman.drive-shares).content.contents
        );
      };
    };
}
