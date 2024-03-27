{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.eza;
in {
  options.mine.eza = {
    enable = mkBoolOpt true "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.eza
    ];
  };
}
