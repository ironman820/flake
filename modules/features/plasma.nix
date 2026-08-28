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
        home.packages = [ ];
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
                  Effect-overview.BorderActivate = 9;
                  Xwayland.Scale = 1;
                };
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
              shortcuts = {
                kmserver."Lock Session" = [
                  "Screensaver"
                  "Meta+Ctrl+L"
                ];
                kwin."Swap Tiled Window Down" = [
                  "Meta+Shift+J"
                  "Meta+Shift+Down"
                ];
                kwin."Swap Tiled Window Left" = [
                  "Meta+Shift+H"
                  "Meta+Shift+Left"
                ];
                kwin."Swap Tiled Window Right" = [
                  "Meta+Shift+L"
                  "Meta+Shift+Right"
                ];
                kwin."Swap Tiled Window Up" = [
                  "Meta+Shift+K"
                  "Meta+Shift+Up"
                ];
                kwin."Tiling Focus Down" = [
                  "Meta+J"
                  "Meta+Down"
                ];
                kwin."Tiling Focus Left" = [
                  "Meta+H"
                  "Meta+Left"
                ];
                kwin."Tiling Focus Right" = [
                  "Meta+L"
                  "Meta+Right"
                ];
                kwin."Tiling Focus Up" = [
                  "Meta+K"
                  "Meta+Up"
                ];
                kwin."Window Close" = [
                  "Alt+F4"
                  "Meta+Q"
                ];
                kwin."Window Grow Horizontal" = "Meta+Y";
                kwin."Window Maximize" = [
                  "Meta+PgUp"
                  "Meta+Shift+M"
                ];
                kwin."Window Shrink Horizontal" = "Meta+Shift+Y";
                plasmashell."manage activities" = [ ];
                "services/org.kde.konsole.desktop"._launch = [ ];
              }
              // mkIf (osConfig.ironman.browser == pkgs.brave) {
                "org.chromium.Chromium"."189254525C2995BCF141B90AE0CFA0E4-MediaPrevTrack" = [ ];
                "org.chromium.Chromium"."789D4A8DD37264E4A9D1003B7815A8F1-MediaPlayPause" = [ ];
                "org.chromium.Chromium"."808F2B98A91BFA0FC4164AF05BB516AC-MediaStop" = [ ];
                "org.chromium.Chromium".D88FD5032C22FF295F83A92DC60FE751-MediaNextTrack = [ ];
              }
              // mkIf (osConfig.ironman.terminal == pkgs.ghostty) {
                "services/com.mitchellh.ghostty.desktop"._launch = [
                  "Ctrl+Alt+T"
                  "Meta+Return"
                ];
              }
              // mkIf (osConfig.ironman.terminal == pkgs.kitty) {
                "services/kitty.desktop".__launch = "Ctrl+Alt+T";
              };
              workspace = {
                colorScheme = "BreezeDark";
                cursor.theme = "breeze_cursors";
                lookAndFeel = "org.kde.breezedark.desktop";
                theme = "breeze-dark";
                wallpaperFillMode = "preserveAspectCrop";
                wallpaperSlideShow.path = "/home/${osConfig.ironman.user.name}/Wallpapers";
              };
            };
        };
      };
  };
}
