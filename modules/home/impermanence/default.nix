{
  lib,
  options,
  config,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) attrs either listOf str;

  cfg = config.mine.home.impermanence;
in {
  options.mine.home.impermanence = {
    enable = mkEnableOption "Enable the module";
    directories = mkOpt (listOf (either attrs str)) [
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Videos"
      ".config/flake"
      ".gnupg"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"
    ] "List of directories to save for home";
    files = mkOpt (listOf (either attrs str)) [] "list of files to save for home";
  };

  config = mkIf cfg.enable {
    home.persistence."/persist/home" = {
      allowOther = true;
      directories = mkAliasDefinitions options.mine.home.impermanence.directories;
      files = mkAliasDefinitions options.mine.home.impermanence.files;
    };
  };
}
