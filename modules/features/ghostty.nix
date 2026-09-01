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
          background-opacity = 0.90;
          background-blur = true;
          font-family = "IosevkaTerm Nerd Font Mono";
          font-size = 12;
        };
        systemd.enable = true;
      };
    };
  };
}
