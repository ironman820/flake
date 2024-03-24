{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.nix;
  imp = config.mine.home.impermanence.enable;
in {
  options.mine.home.nix = {
    enable = mkBoolOpt true "Enable the module";
  };
  config = mkIf cfg.enable {
    home.persistence."/persist/home".directories = mkIf imp [
      ".cache/nix"
      ".cache/nix-index"
      ".local/share/nix"
    ];
  };
}
