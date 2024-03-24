{
  config,
  lib,
  options,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkIf;
  inherit (lib.lists) flatten;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) listOf str;
  inherit (pkgs) writeShellScript;

  cfg = config.mine.home.just;
  opt = options.mine.home.just;
  os = osConfig.mine.just;
in {
  options.mine.home.just = {
    enable = mkBoolOpt os.enable "Install Just";
    apps = mkOpt (listOf str) [] "Lines to add to apps profile";
    homePersist = mkOpt (listOf str) [] "Lines to add to the persistence setup for the user";
    rootPersist = mkOpt (listOf str) [] "Lines to add to the persistence setup for the system";
    updates = mkOpt (listOf str) [] "Lines to add to the update script";
  };

  config = mkIf cfg.enable {
    mine.home.just.rootPersist = [
      "echo $(whoami)"
    ];
    home = {
      # ROOT
      # mkdir -p ${rootPersist}/{var,etc}
      # mkdir -p ${rootPersist}/root/.cache/nix
      # mkdir -p ${rootPersist}/root/.local/share/nix
      # mkdir -p ${rootPersist}/var/lib/{sddm,systemd}
      # mkdir -p ${rootPersist}/etc/{NetworkManager,nixos}
      # cp -R /root/.cache/nix/eval-cache-v5 ${rootPersist}/root/.cache/nix/
      # touch ${rootPersist}/root/.local/share/nix/trusted-settings.json
      # mv /var/log ${rootPersist}/var/
      # mv /var/lib/bluetooth ${rootPersist}/var/lib/
      # mv /var/lib/nixos ${rootPersist}/var/lib/
      # mv /var/lib/sddm/state.conf ${rootPersist}/var/lib/sddm/
      # mv /var/lib/systemd/coredump ${rootPersist}/var/lib/systemd/
      # mv /etc/NetworkManager/system-connections ${rootPersist}/etc/NetworkManager/
      # mv /etc/machine-id ${rootPersist}/etc/
      # mv /etc/nixos/keys.txt ${rootPersist}/etc/nixos/
      #
      # HOME
      # mkdir -p ${homePersist}
      # chown -R ${config.mine.home.user.name}: ${homePersist}
      # mkdir -p ${homePersist}/.cache/nix
      # mkdir -p ${homePersist}/.config/sops/age
      # mkdir -p ${homePersist}/.local/share/{keyrings,nix}
      # mv Documents ${homePersist}/
      # mv Downloads ${homePersist}/
      # mv Music ${homePersist}/
      # mv Pictures ${homePersist}/
      # mv Videos ${homePersist}/
      # cp -R .cache/nix/eval-cache-v5 ${homePersist}/.cache/nix/
      # cp -R .config/flake ${homePersist}/.config/
      # mv .nixops ${homePersist}/
      # mv .local/share/direnv ${homePersist}/.local/share/
      # touch ${homePersist}/.local/share/nix/trusted-settings.json
      # mv .config/sops/age/keys.txt ${homePersist}/.config/sops/age/
      # mkdir -p ${homePersist}/.ssh
      # touch ${homePersist}/.ssh/known_hosts
      # touch ${homePersist}/.ssh/known_hosts.old
      file = {
        ".justfile".text = let
          apps = concatStringsSep "\n          " (flatten (mkAliasDefinitions opt.apps).content.contents);
          homePersist = concatStringsSep "\n          " (flatten (mkAliasDefinitions opt.homePersist).content.contents);
          updates = concatStringsSep "\n          " (flatten (mkAliasDefinitions opt.updates).content.contents);
        in ''
          default:
            @just --list

          apps:
            flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak install -uy com.usebottles.bottles
            flatpak install -uy com.github.tchx84.Flatseal
            flatpak install -uy org.gnome.gitlab.YaLTeR.VideoTrimmer
            ${apps}

          bios:
            systemctl reboot --firmware-setup

          set-impermanence:
            #!/usr/bin/env bash
            sudo ~/scripts/just/root-persist.sh
            ${homePersist}

          switch:
            nh os switch
            systemctl --user restart sops-nix.service

          update:
            #!/usr/bin/env bash
            nh os switch -u
            systemctl --user restart sops-nix.service
            flatpak update -y
            ${updates}
        '';
        "scripts/just/root-persist.sh".source = writeShellScript "root-persist.sh" (
          concatStringsSep "\n" (
            flatten
            (
              mkAliasDefinitions opt.rootPersist
            )
            .content
            .contents
          )
        );
      };
      shellAliases = {
        "hs" = "just home-switch";
        "js" = "just switch";
        "ju" = "just update";
      };
    };
  };
}
