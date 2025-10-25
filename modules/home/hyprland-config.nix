{ flakeRoot, ...}:
{
  flake.homeModules.hyprland-config =
    { config, ... }:
    {
      home.sessionVariables.NIXOS_OZONE_WL = "1";
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
          windowrule = [
            "fullscreen, class:Screensaver"
          ];
        };
      };
      xdg.configFile = {
        "omarchy/current/background".source = flakeRoot + "/.config/backgrounds/voidbringer.png";
        "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      };
    };
}
