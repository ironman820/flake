{ moduleWithSystem, ... }: {
  flake.nixosModules.guiApps = moduleWithSystem (
    perSystem@{ inputs', ... }:
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        feishin
        # freecad
        google-chrome
        obsidian
        remmina
        udiskie
        vlc
        # Zen Browser
        inputs'.zen-browser.packages.default
      ];
      programs = {
        appimage = {
          enable = true;
          binfmt = true;
        };
        firefox.enable = true;
      };
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };
    }
  );
}
