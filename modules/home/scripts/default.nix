{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;
  cfg = config.mine.home.scripts;
in {
  options.mine.home.scripts = {
    enable = mkBoolOpt true "Enable the default settings?";
  };

  config = mkIf cfg.enable { home.file."scripts".source = ./files; };
}
