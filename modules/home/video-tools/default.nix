{ pkgs, config, lib, ...}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.ironman) mkBoolOpt;
  cfg = config.ironman.home.video-tools;
in {
  options.ironman.home.video-tools = {
    enable = mkEnableOption "Enable video editing tools like ffmpeg.";
    handbrake = mkBoolOpt false "Install Handbrake";
  };

  config = mkIf cfg.enable {
    home.packages = mkMerge [
      (with pkgs; [
        ffmpeg
      ])
      (mkIf (config.ironman.home.gnome.enable && cfg.handbrake) (
        with pkgs; [
          handbrake
        ]
      ))
    ];
  };
}
