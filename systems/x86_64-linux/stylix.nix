{ lib, pkgs, ... }:
let
  inherit (lib) mkForce;
in
{
  config = {
    stylix = {
      fonts = {
        serif = {
          package = pkgs.nerdfonts;
          name = "FiraCode Nerd Font Retina";
        };

        sansSerif = {
          package = pkgs.nerdfonts;
          name = "FiraCode Nerd Font Retina";
        };

        monospace = {
          package = mkForce pkgs.nerdfonts;
          name = mkForce "Inconsolata Nerd Font Mono Regular";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
      opacity.terminal = 0.99;
      polarity = "dark";
    };
  };
}
