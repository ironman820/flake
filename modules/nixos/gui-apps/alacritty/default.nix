{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine.user.settings.applications) terminal;
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.gui-apps.alacritty;
in {
  options.mine.gui-apps.alacritty = {
    enable = mkBoolOpt (terminal == "alacritty") "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alacritty
      nerdfonts
    ];
  };
}
