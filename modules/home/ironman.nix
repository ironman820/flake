{
  flake.homeModules.ironman = { config, lib, options, osConfig, ... }:
    with lib; {
    options.ironman = {
      lazygit_config_files = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "LazyGit config file list";
      };
      personal_laptop = mkOption {
        type = types.bool;
        default = osConfig.ironman.personal_laptop;
        description = "Personal laptop";
      };
      work_laptop = mkOption {
        type = types.bool;
        default = osConfig.ironman.work_laptop;
        description = "Work laptop";
      };
      zed_device = mkOption {
        type = types.str;
        default = osConfig.ironman.zed_device;
        description = "Device ID to set in the ZED_DEVICE_ID environment variable";
      };
    };
    config.home.sessionVariables.LG_CONFIG_FILE = let
      configFolder = "${config.xdg.configHome}/lazygit";
    in concatStringsSep "," ([
      "${configFolder}/config.yml"
    ] ++ lists.flatten (mkAliasDefinitions options.ironman.lazygit_config_files).content.contents);
  };
}
