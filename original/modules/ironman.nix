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
        plasma = mkEnableOption "plasma";
        syncthing = {
          cert = mkOption {
            default = null;
            type = types.nullOr types.path;
          };
          devices = mkOption {
            default = { };
            type = types.attrs;
          };
          folders = mkOption {
            default = { };
            type = types.attrs;
          };
          key = mkOption {
            default = null;
            type = types.nullOr types.path;
          };
        };
        work_laptop = mkEnableOption "work laptop";
        zed_device = mkOption {
          type = types.str;
          default = "";
          description = "Device ID to set in the ZED_DEVICE_ID environment variable";
        };
      };
      config = {
        services.autofs.autoMaster = strings.concatStringsSep "\n" (
          lists.flatten (mkAliasDefinitions options.ironman.drive-shares).content.contents
        );
      };
    };
}
