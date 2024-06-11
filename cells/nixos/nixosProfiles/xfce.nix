{
  cell,
  inputs,
  lib,
  options,
  config,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars.xfce;
  l = nixpkgs.lib // mine.lib // builtins;
  o = options.vars.xfce;
  t = l.types;
in {
  options.vars.xfce = {
    enableScreensaver = l.mkBoolOpt true "Enable screensaver";
    excludePackages = l.mkOpt (t.listOf t.pkgs) [] "List of packages to exclude";
  };
  config = {
    environment.xfce.excludePackages = l.mkAliasDefinitions o.excludePackages;
    services.xserver.desktopManager.xfce = {
      inherit (c) enableScreensaver;
      enable = true;
    };
  };
}
