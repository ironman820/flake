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
      inherit (lib.types)
        lines
        listOf
        str
        ;
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
        extraLines = mkOption {
          default = "";
          description = "Extra lines to add to the end of the justfile";
          type = lines;
        };
        updates = mkOption {
          type = listOf str;
          default = [ ];
          description = "Lines to add to the update script";
        };
      };

      config.home = {
        file = {
          ".justfile".text =
            let
              inherit (config.ironman.just) extraLines;
              apps = writeShellScript "apps.sh" (
                concatStringsSep "\n" (flatten (mkAliasDefinitions opt.apps).content.contents)
              );
              updates = writeShellScript "updates.sh" (
                concatStringsSep "\n" (flatten (mkAliasDefinitions opt.updates).content.contents)
              );
            in
            ''
              default:
                @just --list

              apps:
                ${apps}

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
                ${updates}

              ${extraLines}
            '';
        };
        shellAliases = {
          "jc" = "just check";
          "js" = "just switch";
          "ju" = "just update";
        };
      };
    };
}
