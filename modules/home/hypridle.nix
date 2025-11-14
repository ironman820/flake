{
  flake.homeModules.hypridle =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        terminaltexteffects
      ];
      services.hypridle =
        let
          omarchy-cmd-screensaver = pkgs.writeShellScript "omarchy-cmd-screensaver" ''
            screensaver_in_focus() {
              hyprctl activewindow -j | jq -e '.class == "Screensaver"' >/dev/null 2>&1
            }

            exit_screensaver() {
              hyprctl keyword cursor:invisible false
              pkill -x tte 2>/dev/null
              pkill -f "alacritty --class Screensaver" 2>/dev/null
              exit 0
            }

            trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT

            hyprctl keyword cursor:invisible true &>/dev/null

            while true; do
              effect=$(tte 2>&1 | grep -oP '{\K[^}]+' | tr ',' ' ' | tr ' ' '\n' | sed -n '/^beams$/,$p' | sort -u | shuf -n1)
              tte -i ${config.xdg.configHome}/omarchy/branding/screensaver.txt \
                --frame-rate 240 --canvas-width 0 --canvas-height $(($(tput lines) - 2)) --anchor-canvas c --anchor-text c \
                "$effect" &

              while pgrep -x tte >/dev/null; do
                if read -n 1 -t 3 || ! screensaver_in_focus; then
                  exit_screensaver
                fi
              done
            done
          '';
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
                --config-file ${config.xdg.dataHome}/omarchy/default/alacritty/screensaver.toml \
                -e ${omarchy-cmd-screensaver}
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
      xdg = {
        configFile."omarchy/branding/screensaver.txt" = {
          inherit (config.xdg.dataFile."omarchy/logo.txt") text;
        };
        dataFile."omarchy/default/alacritty/screensaver.toml".text = ''
          [colors.primary]
          background = "0x000000"

          [colors.cursor]
          cursor = "0x000000"

          [font]
          size = 18.0

          [window]
          opacity = 1.0
        '';
      };
    };
}
