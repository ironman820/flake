{
  cell,
  inputs,
  options,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  inherit (pkgs) writeShellScript;
  l = nixpkgs.lib // mine.lib // builtins;
  ll = l.lists;
  o = options.vars.just;
  t = l.types;
in {
  options.vars.just = {
    apps = l.mkOpt (t.listOf t.str) [] "Lines to add to apps profile";
    homePersist = l.mkOpt (t.listOf t.str) [] "Lines to add to the persistence setup for the user";
    rootPersist = l.mkOpt (t.listOf t.str) [] "Lines to add to the persistence setup for the system";
    updates = l.mkOpt (t.listOf t.str) [] "Lines to add to the update script";
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

        set-impermanence:
          #!/usr/bin/env bash
          sudo ~/scripts/just/root-persist.sh
          ~/scripts/just/home-persist.sh

        switch:
          nh os switch
          systemctl --user restart sops-nix.service

        update:
          #!/usr/bin/env bash
          nh os switch -u
          systemctl --user restart sops-nix.service
          ~/scripts/just/updates.sh
      '';
      "scripts/just/apps.sh".source = writeShellScript "apps.sh" (l.concatStringsSep "\n" (ll.flatten (l.mkAliasDefinitions o.apps).content.contents));
      "scripts/just/home-persist.sh".source = writeShellScript "home-persist.sh" (l.concatStringsSep "\n" (ll.flatten (l.mkAliasDefinitions o.homePersist).content.contents));
      "scripts/just/root-persist.sh".source = writeShellScript "root-persist.sh" (
        l.concatStringsSep "\n" (
          ll.flatten
          (
            l.mkAliasDefinitions o.rootPersist
          )
          .content
          .contents
        )
      );
      "scripts/just/updates.sh".source = writeShellScript "updates.sh" (l.concatStringsSep "\n" (ll.flatten (l.mkAliasDefinitions o.updates).content.contents));
    };
    shellAliases = {
      "hs" = "just home-switch";
      "jc" = "just check";
      "js" = "just switch";
      "ju" = "just update";
    };
  };
}
