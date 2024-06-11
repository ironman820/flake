{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  inherit (pkgs) writeShellScript;
  c = config.vars.de.qtile;
  l = nixpkgs.lib // mine.lib // builtins;
  t = l.types;
in {
  options.vars.de.qtile = {
    backlightDisplay = l.mkOpt t.str "acpi_video0" "Display to monitor backlight";
    screenSizeCommand =
      l.mkOpt t.str "" "Command to run to change the screen resolution.";
  };

  config = {
    home.packages = with pkgs; [flameshot zathura];
    xdg.configFile = {
      "qtile/autostart.sh".source = writeShellScript "autostart.sh" ''
        ${c.screenSizeCommand}
        nm-applet &
      '';
      "qtile/config.py".source = ./config/config.py;
      "qtile/display.py".text = ''
        watch_display = "${c.backlightDisplay}"
      '';
      "qtile/settings".source = ./config/settings;
    };
  };
}
