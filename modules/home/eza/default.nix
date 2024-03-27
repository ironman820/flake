{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.eza;
  os = osConfig.mine.eza;
in {
  options.mine.home.eza = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    programs.eza = {
      inherit (cfg) enable;
      enableAliases = true;
      extraOptions = ["--group-directories-first" "--header"];
      git = true;
      icons = true;
    };
  };
}
