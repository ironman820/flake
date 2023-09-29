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
      "gotobed" = {
        Unit.Description = "myalarm Go to bed";
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = ''${pkgs.ironman.myalarm}/bin/myalarm.py "Go To Bed!"'';
      };
      "shouldhaveleft" = {
        Unit.Description = "myalarm Leave!";
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = ''${pkgs.ironman.myalarm}/bin/myalarm.py "You should have left! GO!"'';
      };
    };
    timers = {
      "gotobed" = {
        Install.WantedBy = [ "timers.target" ];
        Timer.OnCalendar = "Mon..Fri 23:00:00";
      };
      "shouldhaveleft" = {
        Install.WantedBy = [ "timers.target" ];
        Timer.OnCalendar = "Mon..Fri 23:00:00";
      };
    };
  };
}
