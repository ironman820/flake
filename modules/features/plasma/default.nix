{
  inputs,
  self,
  ...
}:
{
  flake = {
    nixosModules.plasma = { pkgs, ... }: {
      imports = with self.nixosModules; [
        inputs.kineticwe.nixosModules.default
        noctalia
        sddm
      ];
      environment.systemPackages = [
        pkgs.kdePackages.partitionmanager
      ];
      programs.kineticwe.enable = true;
      services = {
        desktopManager.plasma6.enable = true;
        # Kinetic doesn't like the plasma-login-manager currently
        # displayManager.plasma-login-manager.enable = true;
      };
    };
    homeModules.plasma =
      {
        config,
        lib,
        osConfig,
        pkgs,
        ...
      }:
      {
        imports = with inputs; [
          kineticwe.homeModules.default
          self.homeModules.noctalia
          plasma-manager.homeModules.plasma-manager
        ];
        home.activation.ironmanShortcuts =
          let
            kglobalshortcutsrc = pkgs.writeText "kglobalshortcutsrc" (builtins.readFile ./kglobalshortcutsrc);
          in
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            ln -sf ${kglobalshortcutsrc} ${config.home.homeDirectory}/.config/kglobalshortcutsrc
          '';
        programs = {
          kineticwe.enable = true;
          okular = {
            enable = true;
            general = {
              openFileInTabs = true;
              smoothScrolling = true;
              zoomMode = "fitWidth";
            };
          };
          plasma =
            let
              inherit (lib) mkIf;
            in
            {
              enable = true;
              configFile = {
                baloofilerc.General = {
                  "exclude folders[$e]" = "$HOME/git/nixpkgs/";
                  "only basic indexing" = true;
                };
                kdeglobals.General = {
                  TerminalApplication = "ghostty --gtk-single-instance=true";
                  TerminalService = "com.mitchellh.ghostty.desktop";
                };
                kwinrc = {
                  Desktops = {
                    Name_1 = 1;
                    Name_2 = 2;
                    Name_3 = 3;
                    Name_4 = 4;
                    Name_5 = 5;
                    Name_6 = 6;
                    Name_7 = 7;
                    Name_8 = 8;
                    Name_9 = 9;
                    Number = lib.mkForce 9;
                    Rows = 9;
                  };
                  Effect-overview.BorderActivate = 9;
                  MouseBindings.CommandAllWheel = "Previous/Next Desktop";
                  Tiling = {
                    EnabledLayouts = "MasterStack,CenterTile,Columns,AutoGrid";
                    GapBetween = 20;
                    GapBottom = 10;
                    GapLeft = 15;
                    GapRight = 15;
                    GapTop = 10;
                    TilingBorderMode = "ActiveOnly";
                    TilingBorderThickness = 5;
                    TilingCornerRadius = 10;
                  };
                  Windows.InvertScrollDesktopSwitch = true;
                  Xwayland.Scale = 1;
                };
                kwinrulesrc = {
                  General = {
                    count = 1;
                    rules = "a0317d8e-1f89-4e30-960a-f368ed64c262";
                  };
                  a0317d8e-1f89-4e30-960a-f368ed64c262 = {
                    Description = "Opacity";
                    opacityactive = 98;
                    opacityactiverule = 2;
                    opacityinactive = 95;
                    opacityinactiverule = 2;
                    types = 66461;
                  };
                };
                plasmaparc.General.RaiseMaximumVolume = true;
              };
              fonts = {
                fixedWidth = {
                  family = "Inconsolata Nerd Font Mono";
                  pointSize = 11;
                };
                general = {
                  family = "FiraCode Nerd Font";
                  pointSize = 10;
                };
                menu = {
                  family = "FiraCode Nerd Font";
                  pointSize = 10;
                };
                small = {
                  family = "FiraCode Nerd Font";
                  pointSize = 8;
                };
                toolbar = {
                  family = "FiraCode Nerd Font";
                  pointSize = 10;
                };
                windowTitle = {
                  family = "FiraCode Nerd Font";
                  pointSize = 10;
                };
              };
              kwin = {
                effects = {
                  blur = {
                    enable = true;
                    noiseStrength = 7;
                    strength = 7;
                  };
                  dimAdminMode.enable = true;
                  fallApart.enable = true;
                  minimization.animation = "magiclamp";
                  snapHelper.enable = true;
                  wobblyWindows.enable = true;
                };
                virtualDesktops.number = 1;
              };
              overrideConfig = true;
              powerdevil = {
                AC = {
                  autoSuspend = {
                    action = "sleep";
                    idleTimeout = 900;
                  };
                  displayBrightness = 95;
                  inhibitLidActionWhenExternalMonitorConnected = true;
                  keyboardBrightness = 100;
                  powerButtonAction = "showLogoutScreen";
                  powerProfile = "performance";
                  turnOffDisplay = {
                    idleTimeout = 960;
                    idleTimeoutWhenLocked = 60;
                  };
                  whenLaptopLidClosed = "doNothing";
                  whenSleepingEnter = "hybridSleep";
                };
                battery = {
                  autoSuspend = {
                    action = "sleep";
                    idleTimeout = 600;
                  };
                  dimDisplay = {
                    enable = true;
                    idleTimeout = 300;
                  };
                  dimKeyboard.enable = true;
                  displayBrightness = 75;
                  inhibitLidActionWhenExternalMonitorConnected = false;
                  keyboardBrightness = 50;
                  powerButtonAction = "showLogoutScreen";
                  powerProfile = "balanced";
                  turnOffDisplay = {
                    idleTimeout = 960;
                    idleTimeoutWhenLocked = 60;
                  };
                  whenLaptopLidClosed = "sleep";
                  whenSleepingEnter = "standbyThenHibernate";
                };
                batteryLevels = {
                  criticalLevel = 5;
                  lowLevel = 10;
                };
                general.pausePlayersOnSuspend = true;
                lowBattery = {
                  autoSuspend = {
                    action = "hibernate";
                    idleTimeout = 300;
                  };
                  dimDisplay = {
                    enable = true;
                    idleTimeout = 60;
                  };
                  displayBrightness = 50;
                  inhibitLidActionWhenExternalMonitorConnected = false;
                  keyboardBrightness = 0;
                  powerButtonAction = "sleep";
                  powerProfile = "powerSaving";
                  turnOffDisplay = {
                    idleTimeout = 120;
                    idleTimeoutWhenLocked = 60;
                  };
                  whenLaptopLidClosed = "hibernate";
                  whenSleepingEnter = "standbyThenHibernate";
                };
              };
              session.general.askForConfirmationOnLogout = true;
              # KineticWE does not use the global key daemon and this breaks
              # shortcuts = {
              #   kmserver."Lock Session" = [
              #     "Screensaver"
              #     "Meta+Ctrl+L"
              #   ];
              #   kwn = {
              #     "Swap Tiled Window Down" = [
              #       "Meta+Shift+J"
              #       "Meta+Shift+Down"
              #     ];
              #     "Swap Tiled Window Left" = [
              #       "Meta+Shift+H"
              #       "Meta+Shift+Left"
              #     ];
              #     "Swap Tiled Window Right" = [
              #       "Meta+Shift+L"
              #       "Meta+Shift+Right"
              #     ];
              #     "Swap Tiled Window Up" = [
              #       "Meta+Shift+K"
              #       "Meta+Shift+Up"
              #     ];
              #     "Tiling Focus Down" = [
              #       "Meta+J"
              #       "Meta+Down"
              #     ];
              #     "Tiling Focus Left" = [
              #       "Meta+H"
              #       "Meta+Left"
              #     ];
              #     "Tiling Focus Right" = [
              #       "Meta+L"
              #       "Meta+Right"
              #     ];
              #     "Tiling Focus Up" = [
              #       "Meta+K"
              #       "Meta+Up"
              #     ];
              #     "Window Close" = [
              #       "Alt+F4"
              #       "Meta+Q"
              #     ];
              #     "Window Grow Horizontal" = "Meta+Y";
              #     "Window Maximize" = [
              #       "Meta+PgUp"
              #       "Meta+Shift+M"
              #     ];
              #     "Window Shrink Horizontal" = "Meta+Shift+Y";
              #   };
              #   plasmashell."manage activities" = "None";
              #   "services/org.kde.konsole.desktop"._launch = "None";
              # }
              # // mkIf (osConfig.ironman.browser == pkgs.brave) {
              #   "org.chromium.Chromium"."189254525C2995BCF141B90AE0CFA0E4-MediaPrevTrack" = "None";
              #   "org.chromium.Chromium"."789D4A8DD37264E4A9D1003B7815A8F1-MediaPlayPause" = "None";
              #   "org.chromium.Chromium"."808F2B98A91BFA0FC4164AF05BB516AC-MediaStop" = "None";
              #   "org.chromium.Chromium".D88FD5032C22FF295F83A92DC60FE751-MediaNextTrack = "None";
              # }
              # // mkIf (osConfig.ironman.terminal == pkgs.ghostty) {
              #   "services/com.mitchellh.ghostty.desktop"._launch = [
              #     "Ctrl+Alt+T"
              #     "Meta+Return"
              #   ];
              # }
              # // mkIf (osConfig.ironman.terminal == pkgs.kitty) {
              #   "services/kitty.desktop".__launch = "Ctrl+Alt+T";
              # };
              workspace = {
                colorScheme = "BreezeDark";
                cursor.theme = "breeze_cursors";
                lookAndFeel = "org.kde.breezedark.desktop";
                theme = "breeze-dark";
                wallpaperFillMode = "preserveAspectCrop";
                wallpaperSlideShow.path = "${config.home.homeDirectory}/Wallpapers";
              };
            };
        };
      };
  };
}
