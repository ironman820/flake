{ pkgs, config, lib, inputs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt;
  cfg = config.ironman.home.bat;
in
{
  options.ironman.home.bat = {
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
        config.theme = "Catppuccin-mocha";
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
    xdg.configFile."bat/themes".source = inputs.catppuccin-bat;
  };
}
