{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.plasma = moduleWithSystem (
      perSystem@{ inputs', self', ... }: { config, pkgs, ... }: {
        environment = {
          plasma6.excludePackages = [
            pkgs.kdePackages.elisa
          ];
          systemPackages = with pkgs.kdePackages; [
            krohnkite
            partitionmanager
            inputs'.plasma-manager.packages.rc2nix
            self'.packages.plasma-tokyo-night
            self'.packages.tokyo-night-icons
          ];
        };
        services = {
          displayManager.plasma-login-manager.enable = !config.services.displayManager.sddm.enable;
          desktopManager.plasma6.enable = true;
        };
      }
    );
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
          kate = {
            enable = true;
            editor.inputMode = "vi";
            ui.colorScheme = "Tokyo Night";
          };
          okular = {
            enable = true;
            general = {
              colorScheme = "Tokyo Night";
              openFileInTabs = true;
              showMenuBar = false;
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
              kdeglobals = {
                General = {
                  TerminalApplication = "ghostty --gtk-single-instance=true";
                  TerminalService = "com.mitchellh.ghostty.desktop";
                };
                "KFileDialog Settings" = {
                  "Allow Expansion" = false;
                  "Automatically select filename extension" = true;
                  "Breadcrumb Navigation" = true;
                  "Decoration position" = 2;
                  "Show Full Path" = false;
                  "Show Inline Previews" = true;
                  "Show Speedbar" = true;
                  "Show hidden files" = true;
                  "Sort by" = "Name";
                  "Sort directories first" = true;
                  "Sort hidden files last" = false;
                  "Sort reversed" = false;
                  "Speedbar Width" = 162;
                  "View Style" = "DetailTree";
                };
              };
              kwinrc = {
                Effect-translucency = {
                  ExcludeFullScreen = true;
                  Inactive = 90;
                };
                Plugins.krohnkiteEnabled = true;
                Script-krohnkite = {
                  noTileBorder = true;
                  screenGapBetween = 20;
                  screenGapBottom = 10;
                  screenGapLeft = 15;
                  screenGapRight = 15;
                  screenGapTop = 10;
                };
                Windows.InvertScrollDesktopSwitch = true;
                Xwayland.Scale = 1;
              };
              plasmanotifyrc = {
                "Applications/org.telegram.desktop".Seen = true;
                "Applications/thunderbird".Seen = true;
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
            krunner.position = "center";
            kwin = {
              effects = {
                blur = {
                  enable = true;
                  noiseStrength = 9;
                  strength = 9;
                };
                dimAdminMode.enable = true;
                fallApart.enable = true;
                minimization.animation = "magiclamp";
                snapHelper.enable = true;
                translucency.enable = true;
                wobblyWindows.enable = true;
              };
              virtualDesktops = {
                names = [
                  "1"
                  "2"
                  "3"
                  "4"
                  "5"
                ];
                number = 5;
                rows = 5;
              };
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
              feishin = {
                # "189254525C2995BCF141B90AE0CFA0E4-MediaPrevTrack" = [ ];
                # "789D4A8DD37264E4A9D1003B7815A8F1-MediaPlayPause" = [ ];
                # "808F2B98A91BFA0FC4164AF05BB516AC-MediaStop" = [ ];
                # D88FD5032C22FF295F83A92DC60FE751-MediaNextTrack = [ ];
              };
              ksmserver."Lock Session" = [
                "Screensaver"
                "Meta+Ctrl+Shift+L"
              ];
              kwin = {
                KrohnkiteBTreeLayout = [ ];
                KrohnkiteColumnsLayout = [ ];
                KrohnkiteDecrease = "Meta+D";
                KrohnkiteFloatAll = "Meta+Shift+F";
                KrohnkiteFloatingLayout = [ ];
                KrohnkiteFocusDown = "Meta+J";
                KrohnkiteFocusLeft = "Meta+H";
                KrohnkiteFocusNext = "Meta+.";
                KrohnkiteFocusPrev = [ ];
                KrohnkiteFocusRight = "Meta+L";
                KrohnkiteFocusUp = "Meta+K";
                KrohnkiteGrowHeight = "Meta+Ctrl+J";
                KrohnkiteIncrease = "Meta+I";
                KrohnkiteMonocleLayout = "Meta+M";
                KrohnkiteNextLayout = "Meta+\\\\,none";
                KrohnkitePreviousLayout = "Meta+|";
                KrohnkiteQuarterLayout = [ ];
                KrohnkiteRotate = "Meta+R";
                KrohnkiteRotatePart = "Meta+Shift+R";
                KrohnkiteSetMaster = [ ];
                KrohnkiteShiftDown = "Meta+Shift+J";
                KrohnkiteShiftLeft = "Meta+Shift+H";
                KrohnkiteShiftRight = "Meta+Shift+L";
                KrohnkiteShiftUp = "Meta+Shift+K";
                KrohnkiteShrinkHeight = "Meta+Ctrl+K";
                KrohnkiteShrinkWidth = "Meta+Ctrl+H";
                KrohnkiteSpiralLayout = [ ];
                KrohnkiteSpreadLayout = [ ];
                KrohnkiteStackedLayout = [ ];
                KrohnkiteStairLayout = [ ];
                KrohnkiteTileLayout = "Meta+T";
                KrohnkiteToggleFloat = "Meta+F";
                KrohnkiteTreeColumnLayout = [ ];
                KrohnkitegrowWidth = "Meta+Ctrl+L";
                KrohnkitetoggleDock = [ ];
                Overview = [ ];
                "Switch to Desktop 1" = [
                  "Ctrl+F1"
                  "Meta+1"
                  "Meta+F1"
                ];
                "Switch to Desktop 2" = [
                  "Ctrl+F2"
                  "Meta+2"
                  "Meta+F2"
                ];
                "Switch to Desktop 3" = [
                  "Ctrl+F3"
                  "Meta+3"
                  "Meta+F3"
                ];
                "Switch to Desktop 4" = [
                  "Ctrl+F4"
                  "Meta+4"
                  "Meta+F4"
                ];
                "Switch to Desktop 5" = "Meta+5";
                "Window Close" = [
                  "Alt+F4"
                  "Meta+Q"
                ];
                "Window Maximize" = [
                  "Meta+PgUp"
                  "Meta+Shift+M"
                ];
                "Window to Desktop 1" = "Meta+!";
                "Window to Desktop 2" = "Meta+@";
                "Window to Desktop 3" = "Meta+#";
                "Window to Desktop 4" = "Meta+$";
                "Window to Desktop 5" = "Meta+%";
              };
              plasmashell = {
                "activate task manager entry 1" = [ ];
                "activate task manager entry 2" = [ ];
                "activate task manager entry 3" = [ ];
                "activate task manager entry 4" = [ ];
                "activate task manager entry 5" = [ ];
                "manage activities" = [ ];
              };
              "services/com.mitchellh.ghostty.desktop"._launch = [
                "Ctrl+Alt+T"
                "Meta+Return"
              ];
              "services/org.kde.konsole.desktop"._launch = [ ];
              "services/systemsettings.desktop"._launch = [
                "Tools"
                "Meta+"
              ];
              "services/zen.desktop"._launch = "Meta+W";
            };
            spectacle.shortcuts = {
              captureCurrentMonitor = [ ];
              launchWithoutCapturing = [ ];
            };
            workspace = {
              colorScheme = "TokyoNight";
              cursor.theme = "breeze_cursors";
              iconTheme = "TokyoNight-SE";
              # lookAndFeel = "com.github.Jayy-Dev.Plasma.Tokyo.Night";
              theme = "Tokyo-Night";
              wallpaperFillMode = "preserveAspectCrop";
              wallpaperSlideShow.path = "${config.home.homeDirectory}/Wallpapers";
              windowDecorations = {
                library = "org.kde.kwin.aurorae.v2";
                theme = "__aurorae__svg__TokyoNight";
              };
            };
          };
        };
      };
  };
  perSystem =
    {
      # config,
      # inputs',
      lib,
      pkgs,
      # system,
      ...
    }:
    {
      # apps.NAME = {
      #   meta.description = "";
      #   program = self'.packages.NAME;
      # };
      packages = {
        plasma-tokyo-night = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "plasma-tokyo-night";
          version = "2026.08.15";
          src = inputs.plasma-tokyo-night;
          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/color-schemes
            mkdir -p $out/share/aurorae/themes
            cp colorscheme/TokyoNight.colors $out/share/color-schemes/
            cp -R plasma $out/share/
            cp -R aurorae/TokyoNight $out/share/aurorae/themes/

            runHook postInstall
          '';
          meta = {
            description = "Global Theme for Plasma Desktop based on the Tokyo Night color scheme.";
            homepage = "https://github.com/Jayy-Dev/Plasma-Tokyo-Night";
            license = with lib.licenses; [
              gpl3
            ];
            platforms = lib.platforms.linux;
          };
        });
        tokyo-night-icons = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "tokyo-night-icons";
          version = "0.2.0";
          src = fetchTarball {
            url = "https://github.com/ljmill/tokyo-night-icons/releases/download/v0.2.0/TokyoNight-SE.tar.bz2";
            sha256 = "0x8hb2i523j87ijbng41msac9rffwlvrd76r4h1qsrb864b3b9fv";
          };
          installPhase = ''
            mkdir -p $out/share/icons/TokyoNight-SE
            cp -R * $out/share/icons/TokyoNight-SE/
          '';
          meta = {
            description = "GTK Icon theme inspired by Tokyo Night color scheme";
            homepage = "https://github.com/ljmill/tokyo-night-icons";
            license = [
              lib.licenses.gpl3
            ];
            platforms = lib.platforms.linux;
          };
        });
      };
    };
}
