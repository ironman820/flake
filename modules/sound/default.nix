{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) disabled enabled;
  cfg = config.mine.sound;
in {
  options.mine.sound = {
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
