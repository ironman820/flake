{
  flake.nixosModules.ups =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs) writeShellScript writeText;
      pkg = config.power.ups.package;
      logger = lib.getExe' pkgs.util-linux "logger";
      upsPass = config.power.ups.users.upsadmin.passwordFile;
    in
    {
      power.ups = {
        enable = true;
        mode = "netserver";
        openFirewall = true;
        schedulerRules =
          let
            upssched-cmd = writeShellScript "upssched-cmd" ''
              case $1 in
                muteups)
                  ${pkg}/bin/upscmd -u upsadmin -p "$(cat ${upsPass})" ups@localhost beeper.mute
                  ;;
                onbattups)
                  ${logger} -t upssched-cmd "UPS running on battery"
                  ;;
                onlineups)
                  ${logger} -t upssched-cmd "UPS is back online."
                  ;;
                shutdowncps)
                  ${logger} -t upssched-cmd "CPS is critical, shutting it off"
                  ${pkg}/bin/upscmd -u upsadmin -p "$(cat ${upsPass})" cps@localhost shutdown.return
                  ;;
                shutdowncritical)
                  ${logger} -t upssched-cmd "UPS on battery critical, forced shutdown"
                  ${pkg}/bin/upsmon -c fsd
                  ;;
                upsgone)
                  ${logger} -t upssched-cmd "UPS has been gone too long, can't reach"
                  ;;
                *)
                  ${logger} -t upssched-cmd "Unrecognized command: $1"
                  ;;
              esac
            '';
          in
          toString (
            writeText "upssched.conf" ''
              CMDSCRIPT ${upssched-cmd}
              PIPEFN /etc/nixos/upssched.pipe
              LOCKFN /etc/nixos/upssched.lock

              AT ONBATT ups EXECUTE muteups
              AT ONBATT ups START-TIMER muteups 30
              AT ONLINE ups CANCEL-TIMER muteups
              AT LOWBATT ups EXECUTE shutdowncritical
              AT COMMBAD * START-TIMER commbad 30
              AT COMMOK * CANCEL-TIMER commbad commok
              AT NOCOMM * EXECUTE commbad
              AT SHUTDOWN * EXECUTE powerdown
              AT SHUTDOWN * EXECUTE powerdown
            ''
          );
        upsd = {
          enable = true;
          listen = [
            {
              address = "0.0.0.0";
              port = 3493;
            }
          ];
        };
        upsmon = {
          enable = true;
          settings = {
            MINSUPPLIES = 1;
            SHUTDOWNCMD = "${pkgs.systemd}/bin/shutdown -h now";
            NOTIFYCMD = "${pkg}/bin/upssched";
            POLLFREQ = 5;
            POLLFREQALERT = 5;
            HOSTSYNC = 15;
            DEADTIME = 15;
            MAXAGE = 24;
            POWERDOWNFLAG = "/run/killpower";

            NOTIFYMSG = [
              [
                "ONLINE"
                "UPS %s on line power"
              ]
              [
                "ONBATT"
                "UPS %s on battery"
              ]
              [
                "LOWBATT"
                "UPS %s battary is low"
              ]
              [
                "FSD"
                "UPS %s: forced shutdown in progress"
              ]
              [
                "COMMOK"
                "Communications with UPS %s established"
              ]
              [
                "COMMBAD"
                "Communications with UPS %s lost"
              ]
              [
                "SHUTDOWN"
                "Auto logout and shutdown proceeding"
              ]
              [
                "REPLBATT"
                "UPS %s battery needs to be replaced"
              ]
              [
                "NOCOMM"
                "UPS %s is unavailable"
              ]
              [
                "NOPARENT"
                "upsmon parent process died - shutdown impossible"
              ]
            ];

            NOTIFYFLAG = [
              [
                "ONLINE"
                "SYSLOG+WALL+EXEC"
              ]
              [
                "ONBATT"
                "SYSLOG+WALL+EXEC"
              ]
              [
                "LOWBATT"
                "SYSLOG+WALL+EXEC"
              ]
              [
                "FSD"
                "SYSLOG+WALL+EXEC"
              ]
              [
                "COMMOK"
                "SYSLOG+WALL+EXEC"
              ]
              [
                "COMMBAD"
                "SYSLOG+WALL+EXEC"
              ]
              [
                "SHUTDOWN"
                "SYSLOG+WALL+EXEC"
              ]
              [
                "REPLBATT"
                "SYSLOG+WALL"
              ]
              [
                "NOCOMM"
                "SYSLOG+WALL+EXEC"
              ]
              [
                "NOPARENT"
                "SYSLOG+WALL"
              ]
            ];

            RBWARNTIME = 43200;
            NOCOMMWARNTIME = 600;

            FINALDELAY = 5;
          };
        };
      };
    };
}
