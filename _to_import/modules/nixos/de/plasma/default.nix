{config, lib, ...}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled mkOpt;
  cfg = config.mine.de.plasma;
in {
  options.mine.de.plasma = {
    enable = mkEnableOption "plasma";
  };

  config = mkIf cfg.enable {
    mine.dm.sddm = enabled;
    services = {
      desktopManager.plasma6 = enabled;
    };
  };
}
