{ options, pkgs, config, lib, inputs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) lines;

  cfg = config.ironman.home.just;
in {
  options.ironman.home.just = {
    enable = mkBoolOpt true "Install Just";
    configFile = mkOpt lines "" "The text of the config file";
  };

  config = mkIf cfg.enable {
    ironman.home.just.configFile = ''
      default:
        @just --list

      apps:
        flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak install -uy com.usebottles.bottles
        flatpak install -uy com.github.tchx84.Flatseal
        flatpak install -uy org.gnome.gitlab.YaLTeR.VideoTrimmer

      bios:
        systemctl reboot --firmware-setup

      distrobox-debian:
        echo 'Creating Debian distrobox ...'
        distrobox create --image quay.io/toolbx-images/debian-toolbox:latest -n debian -Y

      distrobox-fedora:
        ./scripts/just/stop-fedora
        distrobox create -i quay.io/toolbx-images/fedora-toolbox:latest -n fedora -Y

      distrobox-opensuse:
        echo 'Creating openSUSE distrobox ...'
        distrobox create --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y

      distrobox-u16:
        ./scripts/just/stop-u16
        echo 'Creating Ubuntu 16.04 distrobox...'
        distrobox create --image ghcr.io/ironman820/ubuntu-toolbox:16.04 -n u16 --init-hooks 'echo "$(uname -n)" > /etc/hostname; unset SESSION_MANAGER' -Y

      distrobox-u18:
        ./scripts/just/stop-u18
        echo 'Creating Ubuntu 18.04 distrobox...'
        distrobox create --image ghcr.io/ironman820/ubuntu-toolbox:18.04 -n u18 --init-hooks 'echo "$(uname -n)" > /etc/hostname; unset SESSION_MANAGER' -Y

      distrobox-ubuntu:
        ./scripts/just/stop-ubuntu
        echo 'Creating Ubuntu distrobox ...'
        distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:latest -n ubuntu -I --init-hooks 'echo "$(uname -n)" > /etc/hostname' -Y

      distrobox-universal:
        echo 'Creating Universal Development distrobox ...'
        distrobox create --image mcr.microsoft.com/devcontainers/universal:latest -n universal -Y

      switch:
        flake switch ~/.config/flake#

      update:
        #!/usr/bin/env bash
        cd ~/.config/flake
        flake update
        flake switch
        flatpak update -y
        distrobox upgrade -a

      upgrade:
        #!/usr/bin/env bash
        just distrobox-ubuntu
        just distrobox-u16
        just distrobox-u18
        cd ~/.config/flake
        flake update
        flake switch
        flatpak update -y
        distrobox upgrade -a
    '';
    home = {
      file.".justfile".text = cfg.configFile;
      packages = with pkgs; [
        just
      ];
      shellAliases = {
        "js" = "just switch";
      };
    };
  };
}

