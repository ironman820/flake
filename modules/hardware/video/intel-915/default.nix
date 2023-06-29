{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.hardware.video.intel-915;
in {
  options.ironman.hardware.video.intel-915 = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "i915.modeset=1"
      "i915.fastboot=1"
      "i915.enable_guc=2"
      "i915.enable_psr=1"
      "i915.enable_fbc=1"
      "i915.enable_dc=2"
    ];
  };
}