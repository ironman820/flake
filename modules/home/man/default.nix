{ pkgs, config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;
  cfg = config.mine.home.man;
in {
  options.mine.home.man = {
    enable = mkBoolOpt true "Install new man pager.";
  };

  config = mkIf cfg.enable {
    home = {
      file.".config/tealdeer".source = ./config;
      packages = with pkgs; [ tealdeer ];
    };
  };
}

