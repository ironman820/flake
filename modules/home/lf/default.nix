{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.lf;
in {
  options.mine.home.lf = {
    enable = mkEnableOption "Enable the lf file manager";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      trashy
    ];
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
