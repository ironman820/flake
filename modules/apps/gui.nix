{
  flake.nixosModules.apps-gui =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        audacity
        blender
        calibre
        catppuccin-kitty
        firefox
        gimp
        kitty
        libreoffice-fresh
        mmex
        obs-studio
        putty
        remmina
        telegram-desktop
        udiskie
        vlc
        virt-viewer
      ];
      programs.winbox = {
        enable = true;
        package = pkgs.winbox4;
      };
    };
}
