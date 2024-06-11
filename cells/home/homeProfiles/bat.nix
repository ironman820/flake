{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.home.tui.bat;
  imp = config.mine.home.impermanence.enable;
in {
  options.mine.home.tui.bat = {
    enable = mkBoolOpt true "Enable the module";
    batman = mkEnableOption "better manpages";
  };
  config = mkIf cfg.enable {
    home = {
      persistence."/persist/home".directories = mkIf imp [
        ".cache/bat"
      ];
      shellAliases = {
        "cat" = "bat";
        "diff" = "batdiff";
        "man" = mkIf cfg.batman "batman";
        "rg" = "batgrep";
        "top" = "btop";
        "watch" = "batwatch --command";
      };
    };
    programs = {
      bash.bashrcExtra = ''
        eval $(${pkgs.bat-extras.batpipe}/bin/batpipe)
      '';
      bat = enabled;
    };
  };
}
