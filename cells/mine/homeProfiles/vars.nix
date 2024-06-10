{
  cell,
  inputs,
  osConfig,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  a = c.applications;
  c = osConfig.vars;
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
    transparency = {
      applicationOpacity = l.mkOpt t.float tr.applicationOpacity "Opacity of applications";
      desktopOpacity = l.mkOpt t.float tr.desktopOpacity "Opacity for desktop items";
      inactiveOpacity = l.mkOpt t.float tr.inactiveOpacity "Interactive application opacity";
      terminalOpacity = l.mkOpt t.float tr.terminalOpacity "Opacity of terminal applications";
    };
  };
}
