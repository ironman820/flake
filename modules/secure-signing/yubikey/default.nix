{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.yubikey;
in {
  options.ironman.yubikey = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.yubikey-personalization ];
    services = {
      pcscd.enable = true;
      udev.packages = with pkgs; [
        yubikey-personalization
      ];
    };
  };
}