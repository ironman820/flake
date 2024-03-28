{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.gui-apps;
in {
  options.mine.gui-apps = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
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
      udiskie
      vlc
      virt-viewer
    ];
  };
}
