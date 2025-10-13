{
  flake.nixosModules.apps-gui =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        audacity
        blender
        # TODO: fix catppuccin-kitty package
        # catppuccin-kitty
        firefox
        gimp
        kitty
        libreoffice-fresh
        obs-studio
        obsidian
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
