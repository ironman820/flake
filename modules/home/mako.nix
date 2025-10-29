{
  flake.homeModules.mako =
    { config, pkgs, ... }:
    {
      services.mako = {
        enable = true;
        extraConfig =
          let
            omarchy-notification-dismiss = pkgs.writeShellScript "omarchy-notification-dismiss" ''
              if (($# == 0)); then
                echo "Usage: omarchy-notification-dismiss <summary>"
                exit 1
              fi

              # Find the first notification whose 'summary' matches the regex in $1
              notification_id=$(makoctl list | grep -F "$1" | head -n1 | sed -E 's/^Notification ([0-9]+):.*/\1/')

              if [[ -n $notification_id ]]; then
                makoctl dismiss -n $notification_id
              fi
            '';
          in
          ''
            [app-name=Spotify]
            invisible=1

            [mode=do-not-disturb]
            invisible=true

            [mode=do-not-disturb app-name=notify-send]
            invisible=false

            [urgency=critical]
            default-timeout=0

            [summary~="Setup Wi-Fi"]
            on-button-left=exec sh -c '${omarchy-notification-dismiss} "Setup Wi-Fi"; omanix-launch-wifi'

            [summary~="Learn Keybindings"]
            on-button-left=exec sh -c '${omarchy-notification-dismiss} "Learn Keybindings"; omanix-menu-keybindings'
          '';
        settings = {
          anchor = "top-right";
          default-timeout = 5000;
          width = 420;
          outer-margin = 20;
          padding = "10,15";
          border-size = 2;
          max-icon-size = 32;
          font = "sans-serif 14px";
        };
      };
    };
}
