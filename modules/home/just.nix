{
  flake.homeModules.just =
    {
      lib,
      options,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkAliasDefinitions mkOption;
      inherit (lib.lists) flatten;
      inherit (lib.strings) concatStringsSep;
      inherit (lib.types) listOf str;
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

              check:
                nix flake check --show-trace

              switch:
                nh os switch
                systemctl --user restart sops-nix.service

              update:
                #!/usr/bin/env bash
                nh os switch -u
                systemctl --user restart sops-nix.service
                ~/scripts/just/updates.sh
            '';
            "scripts/just/apps.sh".source = writeShellScript "apps.sh" (
              concatStringsSep "\n" (flatten (mkAliasDefinitions opt.apps).content.contents)
            );
            "scripts/just/updates.sh".source = writeShellScript "updates.sh" (
              concatStringsSep "\n" (flatten (mkAliasDefinitions opt.updates).content.contents)
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
