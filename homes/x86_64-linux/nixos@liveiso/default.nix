{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
let
  inherit (lib.ironman) enabled;
in
{
  ironman.home = {
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
  home.file.".config/is_personal".text = ''false'';
}
