{ pkgs, ... }:
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
          package = pkgs.nerdfonts;
          name = "Inconsolata Nerd Font Mono Regular";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
      opacity.terminal = 0.8;
      polarity = "dark";
    };
  };
}
