{ pkgs, config, lib, ...}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.mine) mkBoolOpt;
  cfg = config.mine.home.video-tools;
in {
  options.mine.home.video-tools = {
    enable = mkEnableOption "Enable video editing tools like ffmpeg.";
    handbrake = mkBoolOpt false "Install Handbrake";
  };

  config = mkIf cfg.enable {
    home.packages = mkMerge [
      (with pkgs; [
        ffmpeg
      ])
      (mkIf cfg.handbrake (
        with pkgs; [
          handbrake
        ]
      ))
    ];
  };
}
