{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt;
  cfg = config.ironman.home.scripts;
in {
  options.ironman.home.scripts = {
    enable = mkBoolOpt true "Enable the default settings?";
  };

  config = mkIf cfg.enable { home.file."scripts".source = ./files; };
}
