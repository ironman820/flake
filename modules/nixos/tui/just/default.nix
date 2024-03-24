{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.tui.just;
in {
  options.mine.tui.just = {enable = mkBoolOpt true "Install Just";};

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.just];
  };
}
