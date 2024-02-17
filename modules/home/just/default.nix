{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.just;
in {
  options.mine.home.just = {enable = mkBoolOpt true "Install Just";};

  config = mkIf cfg.enable {
    home = {
      file.".justfile".text = ''
        default:
          @just --list

        apps:
          flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
          flatpak install -uy com.usebottles.bottles
          flatpak install -uy com.github.tchx84.Flatseal
          flatpak install -uy org.gnome.gitlab.YaLTeR.VideoTrimmer
          distrobox create -i ghcr.io/ironman820/ironman-ubuntu:22.04 -n ubuntu --home /home/${config.mine.home.user.name}/distrobox

        bios:
          systemctl reboot --firmware-setup

        switch:
          flake switch ~/.config/flake#
          systemctl --user restart sops-nix.service

        update:
          #!/usr/bin/env bash
          cd ~/.config/flake
          flake update
          flake switch
          systemctl --user restart sops-nix.service
          flatpak update -y
          distrobox upgrade -a
      '';
      packages = with pkgs; [just];
      shellAliases = {
        "hs" = "just home-switch";
        "js" = "just switch";
        "ju" = "just update";
      };
    };
  };
}
