{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt;

  cfg = config.ironman.home.just;
in {
  options.ironman.home.just = {enable = mkBoolOpt true "Install Just";};

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

        bios:
          systemctl reboot --firmware-setup

        switch:
          flake switch ~/.config/flake#

        home-switch:
          home-manager switch
          systemctl --user restart sops-nix.service

        update:
          #!/usr/bin/env bash
          cd ~/.config/flake
          flake update
          flake switch
          cd ~/.config/home-manager
          flake update
          home-manager switch
          systemctl --user restart sops-nix.service
          flatpak update -y
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
