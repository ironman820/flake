{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) disabled enabled;

  cfg = config.mine.hardware.sound;
in {
  options.mine.hardware.sound = {
    enable = mkEnableOption "Enable sound";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pavucontrol
      pipewire
    ];
    security.rtkit = enabled;
    services = {
      pipewire = {
        alsa = {
          enable = true;
          support32Bit = true;
        };
        enable = true;
        pulse = enabled;
      };
      pulseaudio = disabled;
    };
  };
}
