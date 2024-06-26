{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.gui-apps.others;
in {
  options.mine.gui-apps.others = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      audacity
      brave
      blender
      calibre
      feishin
      floorp
      gimp
      google-chrome
      keepassxc
      libreoffice-fresh
      # microsoft-edge
      nheko
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
