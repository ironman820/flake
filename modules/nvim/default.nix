{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.nvim;
in {
  options.ironman.nvim = {
    enable = mkBoolOpt false "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    ironman.home.extraOptions.home = {
      packages = with pkgs; [
        nvim
      ];
      shellAliases = {
        "vim" = "nvim";
      };
    };
  };
}
