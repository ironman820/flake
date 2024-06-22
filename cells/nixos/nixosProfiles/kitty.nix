{
  cell,
  inputs,
  pkgs,
}: let
  p = inputs.cells.mine.packages;
in {
  environment.systemPackages = with pkgs; [
    # catppuccin-kitty
    kitty
    p.nerdfonts
  ];
}
