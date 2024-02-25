{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;
  cfg = config.mine.home.bat;
in {
  options.mine.home.bat = {
    enable = mkBoolOpt true "Enable bat installation";
    batman = mkBoolOpt false "Enable batman pager alias";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        delta
        entr
      ];
      shellAliases = {
        "cat" = "bat";
        "diff" = "batdiff";
        "man" = mkIf cfg.batman "batman";
        "rg" = "batgrep";
        "watch" = "batwatch --command";
      };
    };
    programs = {
      bash.bashrcExtra = ''
        eval $(${pkgs.bat-extras.batpipe}/bin/batpipe)
      '';
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
          batpipe
          batwatch
          prettybat
        ];
      };
    };
  };
}
