{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.home.lf;
in {
  options.ironman.home.lf = {
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
