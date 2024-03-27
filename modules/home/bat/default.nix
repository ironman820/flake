{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;
  cfg = config.mine.home.bat;
  os = osConfig.mine.bat;
in {
  options.mine.home.bat = {
    enable = mkBoolOpt os.enable "Enable bat installation";
    batman = mkBoolOpt os.batman "Enable batman pager alias";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      "cat" = "bat";
      "diff" = "batdiff";
      "man" = mkIf cfg.batman "batman";
      "rg" = "batgrep";
      "watch" = "batwatch --command";
    };
    programs = {
      bash.bashrcExtra = ''
        eval $(${pkgs.bat-extras.batpipe}/bin/batpipe)
      '';
      bat = enabled;
    };
  };
}
