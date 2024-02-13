{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) disabled enabled;
  cfg = config.ironman.home.gnome;
in
{
  options.ironman.home.gnome = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        font-antialiasing = "rgba";
      };
      "org/gnome/desktop/notifications" = {
        show-in-lock-screen = false;
      };
      "org/gnome/desktop/privacy" = {
        old-files-age = "unit32 30";
        recent-files-max-age = "30";
        remember-recent-files = true;
        remove-old-trash-files = true;
      };
      "org/gnome/desktop/screensaver" = {
        lock-delay = "unit32 30";
        lock-enabled = true;
      };
      "org/gnome/desktop/session" = {
        idle-delay = "unit32 300";
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>q" ];
      };
      "org/gnome/desktop/wm/preferences" = {
        titlebar-font = "FiraCode Nerd Font Bold 11";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = [ "<Super>f" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        name = "Console";
        command = "kitty";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "caffeine@patapon.info"
          "gnome-compact-top-bar@metehan-arslan.github.io"
          "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
          "lockkeys@vaina.lt"
          "no-overview@fthx"
          "pano@elhan.io"
          "power-profile-switcher@eliapasquali.github.io"
          "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
          "syncthing@gnome.2nv2u.com"
          "tactile@lundal.io"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "weatheroclock@CleoMenezesJr.github.io"
        ];
      };
      "org/gnome/shell/extensions/lockkeys" = {
        style = "show-hide";
      };
      "org/gnome/shell/extensions/pano" = {
        paste-on-select = false;
        play-audio-on-copy = false;
        send-notification-on-copy = false;
      };
      "org/gnome/shell/extensions/tactile" = {
        show-tiles = [ "<Super>w" ];
      };
      "org/gnome/system/location" = {
        enabled = false;
      };
    };
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.tela-icon-theme;
        name = "Tela-black-dark";
      };
    };
    home.packages = (with pkgs; [
      gnome.gnome-tweaks
      gnome-extension-manager
    ]) ++ (with pkgs.gnomeExtensions; [
      appindicator
      caffeine
      compact-top-bar
      lock-keys
      no-overview
      pano
      power-profile-switcher
      syncthing-indicator
      tactile
      weather-oclock
    ]);
    services.gpg-agent.pinentryFlavor = "gnome3";
  };
}
