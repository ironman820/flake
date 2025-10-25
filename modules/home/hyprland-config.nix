{ flakeRoot, ...}:
{
  flake.homeModules.hyprland-config =
    { config, pkgs, ... }:
    {
      home.sessionVariables.NIXOS_OZONE_WL = "1";
      programs = {
        alacritty.enable = true;
      };
      services.hypridle =
        let
          omarchy-launch-screensaver = pkgs.writeShellScript "omarchy-launch-screensaver" ''
            # Exit early if we don't have the tte show
            if ! command -v tte &>/dev/null; then
              exit 1
            fi

            # Exit early if screensave is already running
            pgrep -f "alacritty --class Screensaver" && exit 0

            # Allow screensaver to be turned off but also force started
            if [[ -f ~/.local/state/omarchy/toggles/screensaver-off ]] && [[ $1 != "force" ]]; then
              exit 1
            fi

            focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')

            for m in $(hyprctl monitors -j | jq -r '.[] | .name'); do
              hyprctl dispatch focusmonitor $m

              # FIXME: Find a way to make this generic where we it can work for kitty + ghostty
              hyprctl dispatch exec -- \
                alacritty --class Screensaver \
                --config-file ~/.local/share/omarchy/default/alacritty/screensaver.toml \
                -e omarchy-cmd-screensaver
            done

            hyprctl dispatch focusmonitor $focused
          '';
          omarchy-lock-screen = pkgs.writeShellScript "omarchy-lock-screen" ''
            pidof hyprlock || hyprlock &
          '';
        in
        {
          enable = true;
          settings = {
            general = {
              lock_cmd = "${omarchy-lock-screen}";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
              inhibit_sleep = 3;
            };
            listener = [
              {
                timeout = 150;
                on-timeout = "pidof hyprlock || ${omarchy-launch-screensaver}";
              }
              {
                timeout = 300;
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 330;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
              }
            ];
          };
        };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mod" = "SUPER";
          bind = [
            "$mod, Q, exec, kitty"
            "$mod, W, killactive,"
            "$mod, M, exit,"
            # ", Print, exec, grimblast copy area"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            )
          );
        };
      };
      xdg.configFile = {
        "omarchy/current/background".source = flakeRoot + "/.config/backgrounds/voidbringer.png";
        "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      };
    };
}
