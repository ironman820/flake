{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  environment.systemPackages = with pkgs; [
    bashmount
    bibata-cursors
    bibata-cursors-translucent
    brightnessctl
    catppuccin-cursors
    catppuccin-gtk
    catppuccin-kvantum
    catppuccin-papirus-folders
    feh
    floorp
    pywal
    rofi
    scrot
  ];
  services = {
    gvfs = l.enabled;
    udisks2 = l.enabled;
    xserver.windowManager.qtile = l.enabled;
  };
}
