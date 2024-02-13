{ pkgs, config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt;
  cfg = config.ironman.home.man;
in {
  options.ironman.home.man = {
    enable = mkBoolOpt true "Install new man pager.";
  };

  config = mkIf cfg.enable {
    home = {
      file.".config/tealdeer".source = ./config;
      packages = with pkgs; [ tealdeer ];
    };
  };
}

