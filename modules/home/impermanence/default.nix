{
  config,
  lib,
  options,
  osConfig,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) attrs either listOf str;

  cfg = config.mine.home.impermanence;
  os = osConfig.mine.impermanence;
in {
  options.mine.home.impermanence = {
    enable = mkBoolOpt os.enable "Enable the module";
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
