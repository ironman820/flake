{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;
  cfg = config.mine.man;
in {
  options.mine.man = {
    enable = mkBoolOpt true "Install new man pager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.tealdeer];
  };
}
