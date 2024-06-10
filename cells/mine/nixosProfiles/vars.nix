{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars;
  l = nixpkgs.lib // mine.lib // builtins;
  t = l.types;
in {
  options.vars = {
    applications = {
      browser = l.mkOpt t.str "floorp" "Preferred default browser";
      fileManager = l.mkOpt t.str "yazi" "Preferred file manager";
      terminal = l.mkOpt t.str "kitty" "Preferred terminal";
    };
    transparency = {
      applicationOpacity = l.mkOpt t.float 1.0 "Opacity of applications";
      desktopOpacity = l.mkOpt t.float 0.0 "Opacity for desktop items";
      inactiveOpacity = l.mkOpt t.float 1.0 "Interactive application opacity";
      terminalOpacity = l.mkOpt t.float 0.6 "Opacity of terminal applications";
    };
    username = l.mkOpt l.types.str "ironman" "Default username";
  };
  config.users.users.${c.username}.isNormalUser = true;
}
