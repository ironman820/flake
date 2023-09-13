{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.vscode;
in
{
  options.ironman.vscode = with types; {
    enable = mkBoolOpt config.ironman.gnome.enable "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman.home.extraOptions.home.packages = with pkgs; [
      vscode
    ];
  };
}
