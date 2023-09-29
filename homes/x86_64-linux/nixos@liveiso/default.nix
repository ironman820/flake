{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
with lib;
with lib.ironman;
{
  ironman.home = {
    home.file.".config/is_personal".text = ''false'';
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
