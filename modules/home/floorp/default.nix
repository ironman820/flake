{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.floorp;
  imp = config.mine.home.impermanence.enable;
in {
  options.mine.home.floorp = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    home.persistence."/persist/home".directories = mkIf imp [
      ".floorp"
    ];
  };
}
