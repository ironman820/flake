{ pkgs, config, lib, ...}:

with lib;
let
  cfg = config.ironman.video-tools;
in {
  options.ironman.video-tools = with types; {
    enable = mkBoolOpt false "Enable video editing tools like ffmpeg.";
    handbrake = mkBoolOpt false "Install Handbrake";
  };

  config = mkIf cfg.enable {
    ironman.home.extraOptions.home.packages = mkMerge [
      (with pkgs; [
        ffmpeg
      ])
      (mkIf (config.ironman.gnome.enable && cfg.handbrake) (
        with pkgs; [
          handbrake
        ]
      ))
    ];
  };
}
