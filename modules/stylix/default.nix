{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.stylix;
in
{
  options.ironman.stylix = with types; {
    enable = mkEnableOption "Setup default options";
    image = mkOption {
      description = "Wallpaper path";
      type = either path str;
    };
    polarity = mkOption {
      default = "dark";
      description = "Theme polarity";
      type = str;
    };
  };

  config = mkIf cfg.enable {
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
      image = cfg.image;
      polarity = cfg.polarity;
    };
  };
}
