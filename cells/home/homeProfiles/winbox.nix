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
  vars = l.mkIf (v ? "hyprland") {
    hyprland = {
      windowrule = [
        "workspace 3,^(winbox.exe)$"
      ];
      windowrulev2 = [
        "tile,class:(winbox.exe)"
      ];
    };
  };
}
