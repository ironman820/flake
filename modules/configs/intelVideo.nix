{
  flake.nixosModules.intelVideo =
    {
      pkgs,
      ...
    }:
    {
      boot.kernelParams = [
        "i915.modeset=1"
        "i915.fastboot=1"
        "i915.enable_guc=2"
        "i915.enable_psr=1"
        "i915.enable_fbc=1"
        "i915.enable_dc=2"
      ];
      environment.systemPackages = [
        pkgs.libva-utils
      ];
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
}
