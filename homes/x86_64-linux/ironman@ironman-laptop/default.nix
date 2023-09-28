{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
with lib;
with lib.ironman;
{
  ironman.home = {
    personal-apps.enable = true;
    suites.workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
  programs.git.signing = {
    key = "~/.ssh/github_home";
    signByDefault = builtins.stringLength "~/.ssh/github_home" > 0;
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
