{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  v = config.vars;
in {
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = l.mkIf (v ? "hyprland") true;
    xdgOpenUsePortal = true;
  };
}
