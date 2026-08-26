{
  flake.nixosModules.extraGuiApps =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gimp-with-plugins
        libreoffice-fresh
        telegram-desktop
        virt-viewer
        yubioath-flutter
      ];
      programs = {
        thunderbird.enable = true;
      };
    };
}
