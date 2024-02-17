{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine.home.user.settings) terminal;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled mkOpt;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) either path str;

  cfg = config.mine.home.hyprland;
in {
  options.mine.home.hyprland = {
    enable = mkEnableOption "Setup hyprland";
    primaryScale = mkOpt str "1" "Scaling factor for the primary monitor";
    wallpaper = mkOpt (either path str) "" "Wallpaper to load with hyprpaper";
  };

  config = mkIf cfg.enable {
    home = {
      file = let
        inherit (cfg) primaryScale;
      in {
        ".config/hypr/monitor.conf".text = concatStringsSep "\n" [
          "monitor=HDMI-A-1,preferred,auto,1,mirror,eDP-1"
          "monitor=,highres,auto,${primaryScale}"
          "$mainMod = SUPER"
          ''
            bind = $mainMod, P, exec, hyprctl keyword monitor "eDP-1,1280x720,auto,1"''
          ''
            bind = $mainMod SHIFT, P, exec, hyprctl keyword monitor "eDP-1,highres,auto,${primaryScale}"''
          ''
            bindl = , switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, highres, auto, ${primaryScale}"''
          ''
            bindl = , switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"''
        ];
        ".config/hypr/hyprpaper.conf".text = mkIf (cfg.wallpaper != "") ''
          preload = ${cfg.wallpaper}
          wallpaper = , ${cfg.wallpaper}
        '';
        # ".config/hyprland-autoname-workspaces/config.toml".source =
        #   ./hyprland-autoname-workspaces.toml;
      };
      packages =
        (with pkgs; [
          bibata-cursors
          blueman
          bluez
          bluez-tools
          breeze-icons
          brightnessctl
          cliphist
          dunst
          figlet
          floorp
          freerdp
          gtk4
          grim
          gum
          libadwaita
          man-pages
          mpv
          nwg-look
          pavucontrol
          pfetch
          polkit_gnome
          pywal
          rsync
          slurp
          swappy
          swayidle
          swaylock-effects
          swww
          unzip
          vlc
          wget
          wlogout
        ])
        ++ (with pkgs.xfce; [
          mousepad
          tumbler
        ]);
    };
    mine.home = {
      eza = enabled;
      nvim = enabled;
      rofi = enabled;
      thunar = enabled;
      waybar = enabled;
      xdg = {
        enable = true;
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        bind = [
          "$mainMod, RETURN, exec, ${terminal}"
        ];
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          follow_mouse = 0;
          touchpad.natural_scroll = true;
          sensitivity = 0;
        };
      };
      systemd = {
        enable = true;
        variables = [
          "CLUTTER_BACKEND"
          "DISPLAY"
          "GDK_BACKEND"
          "HYPRLAND_INSTANCE_SIGNATURE"
          "QT_QPA_PLATFORM"
          "QT_AUTO_SCREEN_SCALE_FACTOR"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION"
          "SDL_VIDEODRIVER"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
          "XDG_SESSION_TYPE"
          "XDG_SESSION_DESKTOP"
        ];
      };
    };
  };
}
