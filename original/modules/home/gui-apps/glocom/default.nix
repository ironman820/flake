{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.home.gui-apps.glocom;
in {
  options.mine.home.gui-apps.glocom = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home = {
      de.hyprland.windowrule = [
        "workspace 8,^(gloCOM)$"
      ];
      virtual.podman = enabled;
    };
    xdg.dataFile."applications/gloCOM.desktop".text = ''
      [Desktop Entry]
      Version=1.0
      Encoding=UTF-8
      Name=gloCOM (on ubuntu)
      Type=Application
      Exec=distrobox enter -n ubuntu -- /usr/bin/env bash -c /opt/gloCOM/bin/glocom %u
      Icon=~/.local/share/icons/glocom.png
    '';
    xdg.dataFile."icons/glocom.png".source = ./logo.png;
  };
}
