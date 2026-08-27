{
  flake.homeModules.xfce =
    { config, ... }:
    {
      gtk = {
        enable = true;
        gtk3.extraConfig.Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
        gtk4.extraConfig.Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      xfconf = {
        enable = true;
        settings = {
          keyboards."Default/Numlock" = false;
          xfce4-desktop = {
            "backdrop/screen0/monitoreDP-1/workspace0/backdrop-cycle-enable" = true;
            "backdrop/screen0/monitoreDP-1/workspace0/backdrop-cycle-random-order" = true;
            "backdrop/screen0/monitoreDP-1/workspace0/backdrop-cycle-timer" = 5;
            "backdrop/screen0/monitoreDP-1/workspace0/last-image" = "${config.home.homeDirectory}/Wallpapers/voidbringer.png";
          };
        };
      };
    };
}
