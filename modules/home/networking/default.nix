{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkEnableOption mkIf;

  cfg = config.ironman.home.networking;
in {
  options.ironman.home.networking = {
    enable = mkEnableOption "Setup networkmanager-dmenu";
  };

  config = mkIf cfg.enable {
    home.file.".config/networkmanager-dmenu/config.ini".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/flake/modules/home/networking/nm-dmenu.ini";
  };
}
