{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) disabled enabled;
  cfg = config.ironman.sound;
in
{
  options.ironman.sound = {
    enable = mkEnableOption "Enable sound";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pavucontrol
      pipewire
    ];
    hardware.pulseaudio = disabled;
    security.rtkit = enabled;
    services.pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      enable = true;
      pulse = enabled;
    };
    sound = disabled;
  };
}
