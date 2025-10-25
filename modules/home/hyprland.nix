{ config, ... }:
{
  flake.homeModules.hyprland = {
    imports = with config.flake.homeModules; [
      kitty
    ];
    home.sessionVariables.NIXOS_OZONE_WL = "1";
    programs.bash = {
      historyControl = [ "ignoreboth" ];
      historySize = 32768;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        bind = [
          "$mod, q, exec, kitty"
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
  };
}
