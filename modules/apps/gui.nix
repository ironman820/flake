{
  flake.nixosModules.apps-gui =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        local.catppuccin-kitty
        google-chrome
        kitty
        obsidian
        remmina
        udiskie
        vivaldi
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
