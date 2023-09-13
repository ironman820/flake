{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.gnome;
in
{
  options.ironman.gnome = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    environment = {
      gnome.excludePackages = (with pkgs; [
        gnome-tour
        gnome-photos
      ]) ++ (with pkgs.gnome; [
        cheese
        gnome-maps
        gnome-software
      ]);
      systemPackages = with pkgs; [
        gnome.seahorse
        networkmanagerapplet
      ];
    };
    hardware.pulseaudio = disabled;
    ironman = {
      home.extraOptions = {
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
            command = "kgx";
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
          brave
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
        xdg = enabled;
      };
      user.extraGroups = [
        "networkmanager"
      ];
    };
    networking = {
      firewall.allowedUDPPorts = [
        5678
      ];
      networkmanager = {
        enable = true;
        plugins = with pkgs.gnome; [
          networkmanager-openvpn
        ];
      };
    };
    programs = {
      dconf = enabled;
      gnupg.agent.pinentryFlavor = "gnome3";
      xwayland = enabled;
    };
    security.rtkit = enabled;
    services = {
      flatpak = enabled;
      gnome.gnome-keyring = enabled;
      pipewire = {
        alsa = enabled;
        enable = true;
        pulse = enabled;
      };
      printing = enabled;
      udev.packages = with pkgs.gnome; [ gnome-settings-daemon ];
      xserver = {
        desktopManager.gnome = enabled;
        displayManager = {
          defaultSession = "gnome";
          gdm = enabled;
        };
        enable = true;
        layout = "us";
      };
    };
    sound = enabled;
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
