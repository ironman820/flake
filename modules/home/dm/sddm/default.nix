{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.dm.sddm;
  imp = config.mine.home.impermanence.enable;
  os = osConfig.mine.dm.sddm;
in {
  options.mine.home.dm.sddm = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home.tui.just.rootPersist = mkIf imp [
      "mkdir -p /persist/root/var/lib/sddm"
      "touch /persist/root/var/lib/sddm/state.conf"
    ];
    home.persistence."/persist/home".directories = mkIf imp [
      ".local/share/sddm"
    ];
  };
}
