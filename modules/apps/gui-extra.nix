{
  flake.nixosModules.apps-gui-extra =
  { pkgs, ... }:
  {
    environment.systemPackages = with pkgs; [
        audacity
        blender
        gimp-with-plugins
        libreoffice-fresh
        telegram-desktop
        virt-viewer
        yubioath-flutter
    ];
    programs = {
        obs-studio.enable = true;
        thunderbird.enable = true;
    };
  };
}
