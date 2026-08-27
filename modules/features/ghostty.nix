{
  flake = {
    nixosModules.ghostty =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        options.ironman.ghostty =
          let
            inherit (lib) mkOption types;
          in
          mkOption {
            default = (config.ironman.terminal == pkgs.ghostty);
            description = "Whether to import the full ghostty home module";
            type = types.bool;
          };
      };
    homeModules.ghostty = { lib, osConfig, ... }: {
      programs.ghostty = lib.mkIf osConfig.ironman.ghostty {
        enable = true;
        enableBashIntegration = true;
        settings = {
          background-opacity = 0.80;
          background-blur = true;
          font-family = "IosevkaTerm Nerd Font Mono";
          font-size = 12;
          theme = "tokyonight_night";
        };
        systemd.enable = true;
        themes.tokyonight_night = {
          palette = [
            "0=#15161e"
            "1=#f7768e"
            "2=#9ece6a"
            "3=#e0af68"
            "4=#7aa2f7"
            "5=#bb9af7"
            "6=#7dcfff"
            "7=#a9b1d6"
            "8=#414868"
            "9=#ff899d"
            "10=#9fe044"
            "11=#faba4a"
            "12=#8db0ff"
            "13=#c7a9ff"
            "14=#a4daff"
            "15=#c0caf5"
          ];

          background = "#1a1b26";
          foreground = "#c0caf5";
          cursor-color = "#c0caf5";
          selection-background = "#283457";
          selection-foreground = "#c0caf5";
        };
      };
    };
  };
}
