{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    # catppuccin-kitty
    kitty
    nerdfonts
  ];
}
