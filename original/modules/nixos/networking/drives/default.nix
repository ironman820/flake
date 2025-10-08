{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.lists) flatten;
  inherit (lib.mine) mkOpt;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) listOf str;

  autoMaster = concatStringsSep "\n" (
    flatten (mkAliasDefinitions options.mine.networking.drives.autofs.shares).content.contents
  );
  cfg = config.mine.networking.drives;
in {
  options.mine.networking.drives = {
    autofs = {
      enable = mkEnableOption "Enable the Work SAMBA connections";
      shares = mkOpt (listOf str) [] "List of shares to add to the autoMaster list";
    };
  };

  config = {
    services = {
      autofs = mkIf cfg.autofs.enable {
        inherit autoMaster;
        inherit (cfg.autofs) enable;
      };
    };
  };
}
