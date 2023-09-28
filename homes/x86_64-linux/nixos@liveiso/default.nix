{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
with lib;
with lib.ironman;
{
  ironman.home = {
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
  home.file.".config/is_personal".text = ''false'';
}
