{
  cell,
  inputs,
  osConfig,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  a = c.applications;
  c = osConfig.vars;
  cf = c.fonts;
  l = nixpkgs.lib // mine.lib // builtins;
  t = l.types;
  tr = c.transparency;
in {
  options.vars = {
    applications = {
      browser = l.mkOpt t.str a.browser "Preferred default browser";
      fileManager = l.mkOpt t.str a.fileManager "Preferred file manager";
      terminal = l.mkOpt t.str a.terminal "Preferred terminal";
    };
    fonts = {
      terminalFont = l.mkOpt t.str cf.terminalFont "Default font for the terminal";
      terminalSize = l.mkOpt t.float cf.terminalSize "Size of terminal font";
      waybarSize = l.mkOpt t.int cf.waybarSize "Size of font on waybar";
    };
    transparency = {
      applicationOpacity = l.mkOpt t.float tr.applicationOpacity "Opacity of applications";
      desktopOpacity = l.mkOpt t.float tr.desktopOpacity "Opacity for desktop items";
      inactiveOpacity = l.mkOpt t.float tr.inactiveOpacity "Interactive application opacity";
      terminalOpacity = l.mkOpt t.float tr.terminalOpacity "Opacity of terminal applications";
    };
    wallpaper = l.mkOpt (t.either t.path t.str) c.wallpaper "Wallpaper location";
  };
}
