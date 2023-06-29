{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.development.vscode;
in {
  options.ironman.development.vscode = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    ironman.home.extraOptions = {
      home.packages = [ pkgs.vscode ];
    };
  };
}