{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.tui.man;
  os = osConfig.mine.tui.man;
in {
  options.mine.home.tui.man = {
    enable = mkBoolOpt os.enable "Install new man pager.";
  };

  config = mkIf cfg.enable {
    xdg.configFile."tealdeer/config.toml".text = ''
      [updates]
      auto_update = true
    '';
  };
}
