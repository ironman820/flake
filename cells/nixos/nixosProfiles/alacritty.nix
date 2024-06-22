{
  cell,
  inputs,
  pkgs,
}: let
  p = inputs.cells.mine.packages;
in {
  environment.systemPackages = with pkgs; [
    alacritty
    p.nerdfonts
  ];
}
