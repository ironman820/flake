{
  flake.nixosModules.apps-gui =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        audacity
        blender
        local.catppuccin-kitty
        gimp
        google-chrome
        kitty
        libreoffice-fresh
        obsidian
        putty
        remmina
        telegram-desktop
        udiskie
        vlc
        virt-viewer
        yubioath-flutter
      ];
      programs = {
        firefox.enable = true;
        obs-studio.enable = true;
        thunderbird.enable = true;
        winbox = {
          enable = true;
          package = pkgs.winbox4;
        };
      };
      xdg.portal = {
        enable = true;
        config.common.default = "*";
        xdgOpenUsePortal = true;
      };
    };
}
