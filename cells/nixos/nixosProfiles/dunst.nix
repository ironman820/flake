{
  cell,
  inputs,
  pkgs,
  config,
}: let
  inherit (config.vars.applications) browser;
in {
  environment.systemPackages = with pkgs;
    [
      dunst
      papirus-icon-theme
      rofi
    ]
    ++ [
      pkgs.${browser}
    ];
}
