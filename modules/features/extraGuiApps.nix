{
  flake = {
    nixosModules.extraGuiApps =
      { lib, ... }:
      let
        inherit (lib) mkOption types;
      in
      {
        options.ironman.extraGui = mkOption {
          default = false;
          description = "Whether to install heavier apps like office and thunderbrid";
          type = types.bool;
        };
      };
    homeModules.extraGuiApps =
      {
        osConfig,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (osConfig.ironman) extraGui;
      in
      {
        config = {
          home.packages = lib.mkIf extraGui (
            with pkgs;
            [
              gimp-with-plugins
              libreoffice-stable
              telegram-desktop
              virt-viewer
              yubioath-flutter
            ]
          );
          programs.thunderbird = {
            enable = extraGui;
            settings."privacy.donottrackheader.enabled" = true;
          };
        };
      };
  };
}
