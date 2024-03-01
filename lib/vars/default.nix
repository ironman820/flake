_: {
  vars = {
    applications = {
      browser = "floorp"; # string with just the application name
      fileManager = "yazi"; # String with just the application name
      terminal = "alacritty"; # String for the application name
    };
    stylix = {
      base16Scheme = {
        package = "base16-schemes";
        file = "/share/themes/catppuccin-mocha.yaml"; # Base color scheme for Stylix
      };
      image = ./no-place-like-homeV6.jpg; # image used as the background wallpaper
    };
    transparancy = {
      applicationOpacity = 1.0; # Float for traditional applications
      desktopOpacity = 0.0; # Float for desktop items (bars, widgets, etc.)
      inactiveOpacity = 1.0; # Float for inactive applications
      terminalOpacity = 0.6; # Float for terminal applications
    };
  };
}
