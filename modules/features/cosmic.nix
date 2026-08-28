{ inputs, ... }: {
  flake = {
    nixosModules.cosmic = {
      services = {
        desktopManager.cosmic.enable = true;
        displayManager.cosmic-greeter.enable = true;
        system76-scheduler.enable = true;
      };
    };
    homeModules.cosmic =
      {
        config,
        cosmicLib,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.cosmic-manager.homeManagerModules.cosmic-manager
        ];
        home.activation.ironmanCosmicWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p $HOME/.wallpapers
          rm -f $HOME/.wallpapers/*
          find $HOME/Wallpapers -maxdepth 1 -type f | ${lib.getExe pkgs.parallel} ln -f {} $HOME/.wallpapers/{/}
        '';
        wayland.desktopManager.cosmic =
          let
            inherit (cosmicLib.cosmic) mkRON;
          in
          {
            enable = true;
            compositor.autotile = true;
            resetFiles = true;
            resetFilesDirectories = [
              "config"
            ];
            wallpapers = [
              {
                filter_by_theme = true;
                filter_method = mkRON "enum" "Lanczos";
                output = "all";
                rotation_frequency = 600;
                sampling_method = mkRON "enum" "Alphanumeric";
                scaling_mode = mkRON "enum" "Zoom";
                source = mkRON "enum" {
                  value = [ "${config.home.homeDirectory}/.wallpapers" ];
                  variant = "Path";
                };
              }
            ];
          };
      };
  };
}
