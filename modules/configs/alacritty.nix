{
  flake.homeModules.alacritty =
    { pkgs, ... }:
    {
      programs.alacritty = {
        enable = true;
        settings = {
          general.import =
            let
              tokyonight_night = pkgs.writeText "tokyonight_night.toml" ''
                # -----------------------------------------------------------------------------
                # TokyoNight Alacritty Colors
                # Theme: Tokyo Night
                # Upstream: https://github.com/folke/tokyonight.nvim/raw/main/extras/alacritty/tokyonight_night.toml
                # -----------------------------------------------------------------------------

                # Default colors
                [colors.primary]
                background = '#1a1b26'
                foreground = '#c0caf5'

                # Normal colors
                [colors.normal]
                black = '#15161e'
                red = '#f7768e'
                green = '#9ece6a'
                yellow = '#e0af68'
                blue = '#7aa2f7'
                magenta = '#bb9af7'
                cyan = '#7dcfff'
                white = '#a9b1d6'

                # Bright colors
                [colors.bright]
                black = '#414868'
                red = '#ff899d'
                green = '#9fe044'
                yellow = '#faba4a'
                blue = '#8db0ff'
                magenta = '#c7a9ff'
                cyan = '#a4daff'
                white = '#c0caf5'
              '';
            in
            [ "${tokyonight_night}" ];
          env.TERM = "xterm-256color";

          font = {
            normal = {
              family = "CaskaydiaMono Nerd Font";
              style = "Regular";
            };
            bold = {
              family = "CaskaydiaMono Nerd Font";
              style = "Bold";
            };
            italic = {
              family = "CaskaydiaMono Nerd Font";
              style = "Italic";
            };
            size = 9;
          };

          window = {
            padding = {
              x = 14;
              y = 14;
            };
            decorations = "None";
          };

          keyboard = {
            bindings = [
              {
                key = "Insert";
                mods = "Shift";
                action = "Paste";
              }
              {
                key = "Insert";
                mods = "Control";
                action = "Copy";
              }
            ];
          };
        };
      };
    };
}
