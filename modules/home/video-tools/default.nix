{ pkgs, config, lib, ...}:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.video-tools;
in {
  options.ironman.home.video-tools = with types; {
    enable = mkBoolOpt false "Enable video editing tools like ffmpeg.";
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
