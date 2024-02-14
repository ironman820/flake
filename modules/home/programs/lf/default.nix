{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.home.lf;
in {
  options.mine.home.lf = {
    enable = mkEnableOption "Enable the lf file manager";
  };

  config = mkIf cfg.enable {
    home.packages = (with pkgs; [
      trashy
    ]);
    programs = {
      lf = {
        enable = true;
        keybindings = {
          DD = "%trash $f";
        };
      };
    };
  };
}
