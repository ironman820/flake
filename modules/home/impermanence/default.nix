{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.impermanence;
  os = osConfig.mine.impermanence.enable;
in {
  options.mine.home.impermanence = {
    enable = mkBoolOpt os "Enable the module";
  };

  config = mkIf cfg.enable {
    home.persistence."/persist/home" = {
      allowOther = true;
      directories = [
        ".config/flake"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        ".gnupg"
        ".nixops"
        ".local/share/keyrings"
        ".local/share/direnv"
      ];
    };
  };
}
