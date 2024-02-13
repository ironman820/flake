{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.home.gui-apps;
in {
  options.ironman.home.gui-apps = {
    enable = mkEnableOption "Enable the default settings?";
    hexchat = mkEnableOption "Enable Hexchat";
  };

  config = mkIf cfg.enable {
    home = {
      file."putty/sessions/FS Switch".source = ./config/putty/${"FS%20Switch"};
      packages = with pkgs; [
        brave
        blender
        calibre
        floorp
        gimp
        google-chrome
        libreoffice-fresh
        microsoft-edge
        obs-studio
        putty
        remmina
        # steam
        telegram-desktop
        vlc
        virt-viewer
      ];
      sessionVariables = { BROWSER = "brave"; };
    };
    programs.hexchat = mkIf cfg.hexchat {
      enable = cfg.hexchat;
      channels = {
        irchighway = {
          autojoin = [ "#ebooks" ];
          charset = "UTF-8 (Unicode)";
          options = {
            acceptInvalidSSLCertificates = true;
            autoconnect = true;
            bypassProxy = true;
            forceSSL = false;
          };
          servers = [ "irc.irchighway.net" ];
        };
      };
    };
    services.udiskie = {
      enable = true;
      tray = "never";
    };
  };
}
