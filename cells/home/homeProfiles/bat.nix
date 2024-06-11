{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars.bat;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  options.vars.bat = {
    batman = l.mkEnableOption "better manpages";
  };
  config = {
    home.shellAliases = {
      "cat" = "bat";
      "diff" = "batdiff";
      "man" = l.mkIf c.batman "batman";
      "rg" = "batgrep";
      "top" = "btop";
      "watch" = "batwatch --command";
    };
    programs = {
      bash.bashrcExtra = ''
        eval $(${pkgs.bat-extras.batpipe}/bin/batpipe)
      '';
      bat = l.enabled;
    };
  };
}
