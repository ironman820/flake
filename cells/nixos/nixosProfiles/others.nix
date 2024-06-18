{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    audacity
    brave
    blender
    calibre
    firefox
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
}