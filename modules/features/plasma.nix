{
  inputs,
  self,
  ...
}:
{
  flake = {
    nixosModules.plasma = { config, pkgs, ... }: {
      environment.systemPackages = [
        pkgs.kdePackages.partitionmanager
      ];
      services = {
        displayManager.plasma-login-manager.enable = !config.services.displayManager.sddm.enable;
        desktopManager.plasma6.enable = true;
      };
    };
    homeModules.plasma =
      {
        config,
        lib,
        ...
      }:
      {
        imports = [
          inputs.plasma-manager.homeModules.plasma-manager
          self.homeModules.qt
        ];
        programs = {
          okular = {
            enable = true;
            general = {
              openFileInTabs = true;
              smoothScrolling = true;
              zoomMode = "fitWidth";
            };
          };
          plasma = {
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
              # kwinrc = {
              #   Desktops = {
              #     Name_1 = 1;
              #     Name_2 = 2;
              #     Name_3 = 3;
              #     Name_4 = 4;
              #     Name_5 = 5;
              #     Name_6 = 6;
              #     Name_7 = 7;
              #     Name_8 = 8;
              #     Name_9 = 9;
              #     Number = lib.mkForce 9;
              #     Rows = 9;
              #   };
              #   Effect-overview.BorderActivate = 9;
              #   MouseBindings.CommandAllWheel = "Previous/Next Desktop";
              #   Tiling = {
              #     EnabledLayouts = "MasterStack,CenterTile,Columns,AutoGrid";
              #     GapBetween = 20;
              #     GapBottom = 10;
              #     GapLeft = 15;
              #     GapRight = 15;
              #     GapTop = 10;
              #     TilingBorderMode = "ActiveOnly";
              #     TilingBorderThickness = 5;
              #     TilingCornerRadius = 10;
              #   };
              #   Windows.InvertScrollDesktopSwitch = true;
              #   Xwayland.Scale = 1;
              # };
              # kwinrulesrc = {
              #   General = {
              #     count = 1;
              #     rules = "a0317d8e-1f89-4e30-960a-f368ed64c262";
              #   };
              #   a0317d8e-1f89-4e30-960a-f368ed64c262 = {
              #     Description = "Opacity";
              #     opacityactive = 98;
              #     opacityactiverule = 2;
              #     opacityinactive = 95;
              #     opacityinactiverule = 2;
              #     types = 66461;
              #   };
              # };
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
