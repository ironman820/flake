{
  flake.homeModules.just =
    {
      config,
      lib,
      options,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkAliasDefinitions mkOption;
      inherit (lib.lists) flatten;
      inherit (lib.strings) concatStringsSep;
      inherit (lib.types) float int listOf str;
      inherit (pkgs) writeShellScript;

      opt = options.ironman.just;
    in
    {
      options.ironman.just = {
        apps = mkOption {
          type = listOf str;
          default = [ ];
          description = "Lines to add to apps profile";
        };
        updates = mkOption {
          type = listOf str;
          default = [ ];
          description = "Lines to add to the update script";
        };
        screen = mkOption {
          type = listOf str;
          default = [ ];
          description = "Lines to add to the screen changing script";
        };
        screen_reset = {
          display = mkOption {
            type = str;
            default = "eDP-1";
            description = "The display output's name";
          };
          extraConfig = mkOption {
            type = listOf str;
            default = [ ];
            description = "Extra lines to add to the screen changing script";
          };
          mode = {
            height = mkOption {
              type = int;
              default = 1080;
              description = "Default screen height";
            };
            refresh = mkOption {
              type = float;
              default = 60.;
              description = "Default refresh rate of the screen";
            };
            width = mkOption {
              type = int;
              default = 1920;
              description = "Default screen width";
            };
          };
          scale = mkOption {
            type = float;
            default = 1.;
            description = "The default scaling factor of the display";
          };
        };
      };

      config.home = {
          file = {
            ".justfile".text = ''
              default:
                @just --list

              apps:
                ~/scripts/just/apps.sh

              bios:
                systemctl reboot --firmware-setup

              boot:
                nh os boot --accept-flake-config

              check:
                nix flake check --show-trace

              switch:
                nh os switch --accept-flake-config
                systemctl --user restart sops-nix.service

              update:
                #!/usr/bin/env bash
                nh os switch -u
                systemctl --user restart sops-nix.service
                ~/scripts/just/updates.sh

              screen:
                ~/scripts/just/screen.sh

              screenreset:
                ~/scripts/just/screenreset.sh
            '';
            "scripts/just/apps.sh".source = writeShellScript "apps.sh" (
              concatStringsSep "\n" (flatten (mkAliasDefinitions opt.apps).content.contents)
            );
            "scripts/just/updates.sh".source = writeShellScript "updates.sh" (
              concatStringsSep "\n" (flatten (mkAliasDefinitions opt.updates).content.contents)
            );
            "scripts/just/screen.sh".source = writeShellScript "screen.sh" (
              concatStringsSep "\n" (flatten (mkAliasDefinitions opt.screen).content.contents)
            );
            "scripts/just/screenreset.sh".source = writeShellScript "screenreset.sh" (
              concatStringsSep "\n" ([
                "niri msg output ${config.ironman.just.screen_reset.display} on"
              ] ++ (flatten (mkAliasDefinitions opt.screen_reset.extraConfig).content.contents))
            );
          };
          shellAliases = {
            "jc" = "just check";
            "js" = "just switch";
            "ju" = "just update";
          };
        };
      };
}
