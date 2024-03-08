{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.lists) flatten;
  inherit (lib.mine) enabled mkBoolOpt mkOpt;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) listOf str;

  autoMaster = concatStringsSep "\n" (
    flatten (mkAliasDefinitions options.mine.drives.autofs.shares).content.contents
  );
  cfg = config.mine.drives;
in {
  options.mine.drives = {
    enable = mkBoolOpt true "Load drivers for drives and media";
    autofs = {
      enable = mkEnableOption "Enable the Work SAMBA connections";
      shares = mkOpt (listOf str) [] "List of shares to add to the autoMaster list";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      curlftpfs
      fuse
    ];
    services = {
      autofs = mkIf cfg.autofs.enable {
        inherit autoMaster;
        inherit (cfg.autofs) enable;
      };
      gvfs = enabled;
    };
  };
}
