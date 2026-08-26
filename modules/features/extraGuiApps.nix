{
  flake.homeModules.extraGuiApps =
    { config, lib, pkgs, ... }:
    with lib;
    {
      options.ironman.extraGui = mkOption {
        default = false;
        description = "Whether to install heavier apps like office and thunderbrid";
        type = types.bool;
      };
      config = {
        home.packages = mkIf config.ironman.extraGui (with pkgs; [
          gimp-with-plugins
          libreoffice-stable
          telegram-desktop
          virt-viewer
          yubioath-flutter
        ]);
        programs.thunderbird = {
          enable = config.ironman.extraGui;
          settings."privacy.donottrackheader.enabled" = true;
        };
      };
    };
}
