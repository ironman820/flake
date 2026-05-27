{
  flake.nixosModules.apps-gui =
    { inputs, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        boxbuddy
        local.catppuccin-kitty
        feishin
        freecad
        google-chrome
        kitty
        obsidian
        remmina
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
        config.common.default = "*";
        xdgOpenUsePortal = true;
      };
    };
}
