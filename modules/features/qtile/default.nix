{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.qtile = moduleWithSystem (
      perSystem@{ inputs', ... }:
      { pkgs, ... }:
      let
        qtile-extras = pkgs.python314Packages.qtile-extras.overridePythonAttrs {
          src = inputs.qtile-extras.outPath;
          doCheck = false;
          patches = [ ];
        };
      in
      {
        services.xserver.windowManager.qtile = {
          enable = true;
          extraPackages = p: [
            qtile-extras
          ];
          package = inputs'.qtile.packages.default;
        };
        xdg.portal = {
          config.common.default = "*";
          extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-wlr
          ];
        };
      }
    );
    homeModules.qtile = moduleWithSystem (
      perSystem@{ ... }:
      _: {
        home.sessionVariables = {
          WLR_NO_HARDWARE_CURSORS = 1;
          NIXOS_OZONE_WL = 1;
          MOZ_ENABLE_WAYLAND = 1;
          GDK_BACKEND = "wayland,x11";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          SDL_VIDEODRIVER = "wayland,x11";
        };
        # xdg.configFile."qtile/config.py".source = ./config.py;
      }
    );
  };
}
