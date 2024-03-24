{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.just;
in {
  options.mine.just = {enable = mkBoolOpt true "Install Just";};

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.just];
  };
}
