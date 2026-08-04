{ config, ... }:
{
  flake.homeConfigurations.ironman-server = {
    imports = with config.flake.homeModules; [
      base
      python
    ];
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
    };
  };
}
