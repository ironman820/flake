{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.tui.man;
  imp = config.mine.home.impermanence.enable;
  os = osConfig.mine.tui.man;
in {
  options.mine.home.tui.man = {
    enable = mkBoolOpt os.enable "Install new man pager.";
  };

  config = mkIf cfg.enable {
    mine.home.tui.just.homePersist = mkIf imp [
      "mkdir -p /persist/home/.cache/tealdeer"
    ];
    home.persistence."/persist/home".directories = mkIf imp [
      ".cache/tealdeer"
    ];
    xdg.configFile."tealdeer/config.toml".text = ''
      [updates]
      auto_update = true
    '';
  };
}
