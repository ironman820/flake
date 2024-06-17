{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (pkgs) writeShellScript;
  v = config.vars;
in {
  xdg.dataFile = {
    "dwm/autostart.sh".source = writeShellScript "autostart.sh" ''
      feh --no-fehbg --bg-fill ~/.local/share/dwm/wallpaper.png
    '';
    "dwm/wallpaper.png".source = v.wallpaper;
  };
}
