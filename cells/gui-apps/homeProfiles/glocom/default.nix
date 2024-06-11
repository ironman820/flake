############################################################################################################################
#                                               ! IMPORTANT !                                                              #
# In its current implimentation, you need to enable podman and ensure the ubuntu container is created to use this package! #
############################################################################################################################
{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  v = config.vars;
in {
  vars = l.mkIf (v ? "hyprland") {
    hyprland.windowrule = [
      "workspace 8,^(gloCOM)$"
    ];
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
}
