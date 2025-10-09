{
  config,
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
    };
    networking = enabled;
    sops.secrets.deploy_ed25519 = {
      mode = "0400";
      path = "${config.home.homeDirectory}/.ssh/deploy_ed25519";
    };
    tui.neomutt.personalEmail = true;
    personal-apps = enabled;
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
    waybar.resolution = 768;
  };
  # home = {
  #   packages = [pkgs.tochd];
  # };
}
