{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
with lib;
with lib.ironman;
{
  home.file.".config/is_personal".text = ''false'';
  ironman.home = {
    suites.server = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
