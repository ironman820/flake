{inputs, ...}: {
  vars = {
    applications = {
      browser = "google-chrome"; # string with just the application name
      fileManager = "dolphin"; # String with just the application name
      terminal = "kitty"; # String for the application name
    };
    stylix = {
      base16Scheme = {
        enable = true;
        package = "base16-onedark-scheme";
        file = "theme.yaml"; # Base color scheme for Stylix
      };
      fonts = {
        terminalFont = "IosevkaTerm Nerd Font";
        terminalFontPackage = inputs.nixpkgs.nerd-fonts.iosevka-term;
        terminalSize = 12.0; # Default size of terminal fonts
        waybarSize = 16;
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
