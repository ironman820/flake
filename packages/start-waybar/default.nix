{ pkgs, ... }:
let
  inherit (pkgs) writeShellScriptBin;
in writeShellScriptBin "start-waybar" ''
    CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css"

    trap "${pkgs.killall}/bin/killall .waybar-wrapped" EXIT

    while true; do
        waybar &
        ${pkgs.inotify-tools}/bin/inotifywait -e create,modify $CONFIG_FILES
        ${pkgs.killall}/bin/killall .waybar-wrapped
    done
''
