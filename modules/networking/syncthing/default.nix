{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.networking.syncthing;
in {
  options.ironman.networking.syncthing = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      systemService = false;
      user = config.ironman.user.name;
      openDefaultPorts = ifThenElse config.ironman.firewall.enable true false;
    };

    environment = mkIf config.ironman.desktop.gnome.enable {
      systemPackages = [ pkgs.gnomeExtensions.syncthing-indicator ];
    };
  };
}