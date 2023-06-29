{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.ironman.secure-signing.ssh;
in {
  options.ironman.secure-signing.ssh = with types; {
    enable = mkBoolOpt true "Whether or not to enable Gnome.";
  };

  config = mkIf cfg.enable {
    services.openssh = enabled;
  };
}