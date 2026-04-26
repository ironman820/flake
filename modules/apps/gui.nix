{
  flake.nixosModules.apps-gui =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
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
      ];
      programs = {
        firefox.enable = true;
      };
      xdg.portal = {
        enable = true;
        config.common.default = "*";
        xdgOpenUsePortal = true;
      };
    };
}
