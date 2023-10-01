{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
let
  inherit (lib.ironman) enabled;
in
{
  ironman.home = {
    personal-apps.enable = true;
    suites.workstation = enabled;
    user = enabled;
  };
  systemd.user = {
    services = {
      "gotobedweekdays" = {
        Unit.Description = "myalarm Go to bed";
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = ''${pkgs.ironman.myalarm}/bin/myalarm.py "Go To Bed!"'';
      };
      "gotobedweekends" = {
        Unit.Description = "myalarm Go to bed";
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = ''${pkgs.ironman.myalarm}/bin/myalarm.py "Go To Bed!"'';
      };
      "shouldhaveleft" = {
        Unit.Description = "myalarm Leave!";
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = ''${pkgs.ironman.myalarm}/bin/myalarm.py "Leave for Work"'';
      };
    };
    timers = {
      "gotobedweekdays" = {
        Install.WantedBy = [ "timers.target" ];
        Timer.OnCalendar = "Mon..Thu,Sun 22:00,15:00";
      };
      "gotobedweekends" = {
        Install.WantedBy = [ "timers.target" ];
        Timer.OnCalendar = "Fri,Sat 23:00,15:00";
      };
      "shouldhaveleft" = {
        Install.WantedBy = [ "timers.target" ];
        Timer.OnCalendar = "Mon..Fri 07:10,20:00";
      };
    };
  };
}
