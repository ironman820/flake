{ inputs, self, ... }: {
  flake.homeModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.ironman) personal_laptop work_laptop zed_device;
      inherit (lib) mkIf mkMerge;
    in
    {
      imports = with self.homeModules; [
        ghostty
        noctalia
      ];
      programs.niri = {
        settings = {
          binds = {
            "Mod+1".action.focus-workspace = "";
            "Mod+2".action.focus-workspace = "";
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;
            "Mod+6".action.focus-workspace = 6;
            "Mod+7".action.focus-workspace = 7;
            "Mod+8".action.focus-workspace = 8;
            "Mod+9".action.focus-workspace = 9;
            "Mod+E".action.spawn = lib.getExe pkgs.nautilus;
            "Mod+H".action.focus-column-left = [ ];
            "Mod+J".action.focus-workspace-down = [ ];
            "Mod+K".action.focus-workspace-up = [ ];
            "Mod+L".action.focus-column-right = [ ];
            "Mod+O".action.toggle-overview = [ ];
            "Mod+P".action.spawn-sh = "${lib.getExe pkgs.just} screen";
            "Mod+Q".action.close-window = [ ];
            "Mod+R".action.spawn-sh = "noctalia msg panel-toggle launcher";
            "Mod+U".action.switch-preset-window-height = [ ];
            "Mod+W".action.spawn-sh = lib.getExe inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
            "Mod+Y".action.switch-preset-column-width = [ ];
            "Mod+Z".action.spawn-sh = "env -u WAYLAND_DISPLAY ${lib.getExe pkgs.zed-editor}";
            "Mod+Ctrl+L".action.spawn-sh = "noctalia msg session lock";
            "Mod+Return".action.spawn-sh = lib.getExe pkgs.ghostty;
            "Mod+Shift+1".action.move-column-to-workspace = "";
            "Mod+Shift+2".action.move-column-to-workspace = "";
            "Mod+Shift+3".action.move-column-to-workspace = 3;
            "Mod+Shift+4".action.move-column-to-workspace = 4;
            "Mod+Shift+5".action.move-column-to-workspace = 5;
            "Mod+Shift+6".action.move-column-to-workspace = 6;
            "Mod+Shift+7".action.move-column-to-workspace = 7;
            "Mod+Shift+8".action.move-column-to-workspace = 8;
            "Mod+Shift+9".action.move-column-to-workspace = 9;
            "Mod+Shift+F".action.toggle-window-floating = [ ];
            "Mod+Shift+H".action.move-column-left = [ ];
            "Mod+Shift+J".action.move-column-to-workspace-down = [ ];
            "Mod+Shift+K".action.move-column-to-workspace-up = [ ];
            "Mod+Shift+L".action.move-column-right = [ ];
            "Mod+Shift+M".action.fullscreen-window = [ ];
            "Mod+Shift+P".action.spawn-sh = "${lib.getExe pkgs.just} screenreset";
            "Mod+Shift+Q".action.quit = [ ];
            "Mod+Shift+U".action.switch-preset-window-height-back = [ ];
            "Mod+Shift+Y".action.switch-preset-column-width-back = [ ];
            "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];
            # Core Noctalia binds
            "Mod+Space".action.spawn-sh = "noctalia msg panel-toggle launcher";
            "Mod+S".action.spawn-sh = "noctalia msg panel-toggle control-center";
            "Mod+Comma".action.spawn-sh = "noctalia msg settings-toggle";
            "Mod+Tab".action.spawn-sh = "noctalia msg window-switcher";

            "Print".action.screenshot = [ ];

            # Audio & Brightness
            "XF86AudioPlay" = {
              allow-when-locked = true;
              action.spawn-sh = "noctalia msg media toggle";
            };
            "XF86AudioPrev".action.spawn-sh = "noctalia msg media previous";
            "XF86AudioNext".action.spawn-sh = "noctalia msg media next";
            "XF86AudioStop" = {
              allow-when-locked = true;
              action.spawn-sh = "noctalia msg media stop";
            };
            "XF86AudioRaiseVolume".action.spawn-sh = "noctalia msg volume-up";
            "XF86AudioLowerVolume".action.spawn-sh = "noctalia msg volume-down";
            "XF86AudioMute" = {
              allow-when-locked = true;
              action.spawn-sh = "noctalia msg volume-mute";
            };
            "XF86MonBrightnessUp".action.spawn-sh = "noctalia msg brightness-up";
            "XF86MonBrightnessDown".action.spawn-sh = "noctalia msg brightness-down";
            "XF86Tools".action.spawn-sh = lib.getExe pkgs.feishin;
          };
          blur = {
            passes = 3;
            offset = 3;
            noise = 0.02;
            saturation = 1.5;
          };
          debug = {
            honor-xdg-activation-with-invalid-serial = [ ];
          };
          environment = {
            "NIXOS_OZONE_WL" = "1";
            "ZED_DEVICE_ID" = zed_device;
          };
          gestures.hot-corners.enable = false;
          hotkey-overlay = {
            hide-not-bound = true;
            skip-at-startup = true;
          };
          input.keyboard.xkb.layout = "us";
          layer-rules = [
            {
              matches = [
                {
                  namespace = "^noctalia-backdrop";
                }
              ];
              place-within-backdrop = true;
            }
          ];
          layout = {
            default-column-width.proportion = 1. / 2.;
            preset-column-widths = [
              { proportion = 1. / 4.; }
              { proportion = 1. / 2.; }
              { proportion = 3. / 4.; }
              { proportion = 1.; }
            ];
            preset-window-heights = [
              { proportion = 1.; }
              { proportion = 1. / 4.; }
              { proportion = 1. / 2.; }
              { proportion = 3. / 4.; }
            ];
          };
          outputs = mkMerge [
            (mkIf personal_laptop {
              "eDP-1" = {
                mode = {
                  height = 1200;
                  refresh = 60.;
                  width = 1920;
                };
                scale = 1;
              };
            })
            (mkIf work_laptop {
              "eDP-1" = {
                mode = {
                  height = 1920;
                  refresh = 60.001;
                  width = 2880;
                };
                scale = 1.5;
              };
              "DP-4".enable = false;
            })
          ];
          screenshot-path = "${config.xdg.userDirs.pictures}/Screenshots/Screenshot %Y-%m-%d %H-%M-%S.png";
          spawn-at-startup = [
            { argv = [ "noctalia" ]; }
          ];
          window-rules = [
            {
              clip-to-geometry = true;
              geometry-corner-radius = {
                bottom-left = 20.;
                bottom-right = 20.;
                top-left = 20.;
                top-right = 20.;
              };
            }
            {
              matches = [
                {
                  app-id = "com.mitchellh.ghostty";
                }
              ];
              background-effect.blur = true;
              draw-border-with-background = false;
            }
            {
              matches = [
                {
                  app-id = "dev.noctalia.Noctalia";
                }
              ];
              open-floating = true;
              default-column-width.fixed = 1080;
              default-window-height.fixed = 920;
            }
            {
              matches = [
                {
                  app-id = "roxterm";
                }
              ];
              open-focused = true;
              open-on-workspace = "";
            }
            {
              matches = [
                {
                  app-id = "steam";
                }
                {
                  title = "^notificationtoasts_\d+_desktop$";
                }
              ];
              default-floating-position = {
                x = 10;
                y = 10;
                relative-to = "bottom-right";
              };
            }
            {
              matches = [
                {
                  app-id = "dev.zed.Zed";
                }
              ];
              default-column-width.proportion = 1.;
              default-window-height.proportion = 1.;
              open-focused = true;
              open-on-workspace = "";
            }
            {
              matches = [
                {
                  app-id = "zen";
                }
              ];
              default-column-width.proportion = 1.;
              default-window-height.proportion = 1.;
              open-focused = true;
              open-on-workspace = "";
            }
          ];
          workspaces = {
            "" = { };
            "" = { };
          };
        };
      };
    };
}
