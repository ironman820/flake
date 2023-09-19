{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.vscode;
in
{
  options.ironman.home.vscode = with types; {
    enable = mkBoolOpt config.ironman.home.gnome.enable "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode
    ];
  };
}
