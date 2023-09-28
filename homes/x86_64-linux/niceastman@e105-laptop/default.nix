{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
with lib;
with lib.ironman;
{
  home.file.".config/is_personal".text = ''false'';
  ironman = {
    home = {
      suites.workstation = enabled;
      user.name = config.snowfallorg.user.name;
      work-tools = enabled;
    };
  };
  systemd.user = {
    services."leave" = {
      Unit.Description = "myalarm Go Home";
      Install.WantedBy = [ "default.target" ];
      Service.ExecStart = ''${pkgs.ironman.myalarm}/bin/myalarm.py "Get out of the office!"'';
    };
    timers."leave" = {
      Install.WantedBy = [ "timers.target" ];
      Timer.OnCalendar = "Mon..Fri 17:00:00";
    };
  };
}