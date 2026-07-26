{ inputs, ... }: {
  flake.nixosModules.guiApps =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        boxbuddy
        feishin
        # freecad
        google-chrome
        obsidian
        remmina
        roxterm
        udiskie
        vlc
        zotero
        # Zen Browser - defaults
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
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
        # config.common.default = "*";
        xdgOpenUsePortal = true;
      };
    };
}
