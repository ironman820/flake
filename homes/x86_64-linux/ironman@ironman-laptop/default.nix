{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ../modules.nix
  ];
  mine.home = {
    gui-apps = {
      hexchat = enabled;
      kitty = enabled;
    };
    networking = enabled;
    tui.neomutt.personalEmail = true;
    personal-apps = enabled;
    sops.age.keyFile = "/persist/home/.config/sops/age/keys.txt";
    suites.laptop = enabled;
    user.settings = {
      stylix = {
        fonts = {
          terminalSize = 10.0;
          waybarSize = 12;
        };
        image = ../../../systems/x86_64-linux/ironman-laptop/ffvii.jpg;
      };
      transparancy.terminalOpacity = 0.85;
    };
  };
  home = {
    packages = [pkgs.tochd];
    persistence."/persist/home".directories = [
      "Calibre Library"
      "git"
      "Notes"
      "Notes-old"
      "wallpapers"
      "Work"
    ];
  };
}
