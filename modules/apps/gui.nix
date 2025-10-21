{
  flake.nixosModules.apps-gui =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        audacity
        blender
        local.catppuccin-kitty
        firefox
        gimp
        google-chrome
        kitty
        libreoffice-fresh
        obs-studio
        obsidian
        putty
        remmina
        telegram-desktop
        thunderbird
        udiskie
        vlc
        virt-viewer
        yubioath-flutter
      ];
      programs.winbox = {
        enable = true;
        package = pkgs.winbox4;
      };
    };
}
