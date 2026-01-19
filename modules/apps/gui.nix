{
  flake.nixosModules.apps-gui =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        local.catppuccin-kitty
        feishin
        google-chrome
        kitty
        obsidian
        remmina
        udiskie
        vlc
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
