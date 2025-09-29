{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine.user.settings) stylix transparancy;
  inherit (stylix.fonts) terminalFont;
  inherit (transparancy) terminalOpacity;
  inherit (lib) mkForce;
in {
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
          name = terminalFont;
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
      opacity.terminal = terminalOpacity;
      polarity = "dark";
    };
  };
}
