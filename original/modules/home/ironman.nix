{
  flake.homeModules.ironman = { config, lib, options, osConfig, ... }:
    with lib; {
    options.ironman = {
      zed_device = mkOption {
        type = types.str;
        default = osConfig.ironman.zed_device;
        description = "Device ID to set in the ZED_DEVICE_ID environment variable";
      };
    };
  };
}
