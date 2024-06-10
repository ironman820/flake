{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  h = config.wayland.windowManager.hyprland;
  l = nixpkgs.lib // mine.lib // builtins;
  tsp = v.transparency;
  v = config.vars;
in {
  vars = l.mkIf h.enable {
    hyprland.windowrulev2 = [
      "opacity ${l.toString tsp.applicationOpacity} override ${l.toString tsp.inactiveOpacity} override,class:^(floorp)$"
      "opacity 1.0 override 1.0 override,class:^(floorp)$,title:(.*)(YouTube)(.*)"
    ];
  };
}
