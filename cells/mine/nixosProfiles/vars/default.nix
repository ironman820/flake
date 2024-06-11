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
    fonts = {
      terminalFont = l.mkOpt t.str "IosevkaTerm Nerd Font" "Default font for the terminal";
      terminalSize = l.mkOpt t.float 12.0 "Size of terminal font";
      waybarSize = l.mkOpt t.int 16 "Size of font on waybar";
    };
    transparency = {
      applicationOpacity = l.mkOpt t.float 1.0 "Opacity of applications";
      desktopOpacity = l.mkOpt t.float 0.0 "Opacity for desktop items";
      inactiveOpacity = l.mkOpt t.float 1.0 "Interactive application opacity";
      terminalOpacity = l.mkOpt t.float 0.6 "Opacity of terminal applications";
    };
    username = l.mkOpt l.types.str "ironman" "Default username";
    wallpaper = l.mkOpt (t.either t.path t.str) ./__files/no-place-like-homeV6.jpg "Wallpaper location";
  };
  config.users.users.${c.username}.isNormalUser = true;
}
