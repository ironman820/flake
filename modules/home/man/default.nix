{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;
  cfg = config.mine.home.man;
  os = osConfig.mine.man;
in {
  options.mine.home.man = {
    enable = mkBoolOpt os.enable "Install new man pager.";
  };

  config = mkIf cfg.enable {
    home.file.".config/tealdeer/config.toml".text = ''
      [updates]
      auto_update = true
    '';
  };
}
