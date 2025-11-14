{ flakeRoot, inputs, ... }:
{
  flake.homeModules.hyprland-config =
    { config, pkgs, ... }:
    {
      home = {
        packages = [
          inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
          pkgs.networkmanagerapplet
        ];
        sessionVariables.NIXOS_OZONE_WL = "1";
      };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          # Application bindings
          "$terminal" = "uwsm-app -- $TERMINAL";
          "$browser" = "omanix-launch-browser";

          bind = [
            "SUPER, M, exit,"
            # ", Print, exec, grimblast copy area"
          ];
          bindd = [
            # Copy / Paste
            "SUPER, C, Copy, sendshortcut, CTRL, Insert,"
            "SUPER, V, Paste, sendshortcut, SHIFT, Insert,"
            "SUPER, X, Cut, sendshortcut, CTRL, X,"
            "SUPER CTRL, V, Clipboard, exec, omanix-launch-walker -m clipboard"
            # Close windows
            "SUPER, Q, Close active window, killactive,"
            "CTRL ALT, DELETE, Close all Windows, exec, omanix-hyprland-window-close-all"

            # Control tiling
            "SUPER, J, Toggle split, togglesplit, # dwindle"
            "SUPER, P, Pseudo window, pseudo, # dwindle"
            "SUPER, T, Toggle floating, togglefloating,"
            "SUPER, F, Force full screen, fullscreen, 0"
            "SUPER CTRL, F, Tiled full screen, fullscreenstate, 0 2"
            "SUPER ALT, F, Full width, fullscreen, 1"

            # Move focus with SUPER + arrow keys
            "SUPER, LEFT, Move focus left, movefocus, l"
            "SUPER, RIGHT, Move focus right, movefocus, r"
            "SUPER, UP, Move focus up, movefocus, u"
            "SUPER, DOWN, Move focus down, movefocus, d"

            # Switch workspaces with SUPER + [0-9]
            "SUPER, code:10, Switch to workspace 1, workspace, 1"
            "SUPER, code:11, Switch to workspace 2, workspace, 2"
            "SUPER, code:12, Switch to workspace 3, workspace, 3"
            "SUPER, code:13, Switch to workspace 4, workspace, 4"
            "SUPER, code:14, Switch to workspace 5, workspace, 5"
            "SUPER, code:15, Switch to workspace 6, workspace, 6"
            "SUPER, code:16, Switch to workspace 7, workspace, 7"
            "SUPER, code:17, Switch to workspace 8, workspace, 8"
            "SUPER, code:18, Switch to workspace 9, workspace, 9"
            "SUPER, code:19, Switch to workspace 10, workspace, 10"

            # Move active window to a workspace with SUPER + SHIFT + [0-9]
            "SUPER SHIFT, code:10, Move window to workspace 1, movetoworkspace, 1"
            "SUPER SHIFT, code:11, Move window to workspace 2, movetoworkspace, 2"
            "SUPER SHIFT, code:12, Move window to workspace 3, movetoworkspace, 3"
            "SUPER SHIFT, code:13, Move window to workspace 4, movetoworkspace, 4"
            "SUPER SHIFT, code:14, Move window to workspace 5, movetoworkspace, 5"
            "SUPER SHIFT, code:15, Move window to workspace 6, movetoworkspace, 6"
            "SUPER SHIFT, code:16, Move window to workspace 7, movetoworkspace, 7"
            "SUPER SHIFT, code:17, Move window to workspace 8, movetoworkspace, 8"
            "SUPER SHIFT, code:18, Move window to workspace 9, movetoworkspace, 9"
            "SUPER SHIFT, code:19, Move window to workspace 10, movetoworkspace, 10"

            # TAB between workspaces
            "SUPER, TAB, Next workspace, workspace, e+1"
            "SUPER SHIFT, TAB, Previous workspace, workspace, e-1"
            "SUPER CTRL, TAB, Former workspace, workspace, previous"

            # Swap active window with the one next to it with SUPER + SHIFT + arrow keys
            "SUPER SHIFT, LEFT, Swap window to the left, swapwindow, l"
            "SUPER SHIFT, RIGHT, Swap window to the right, swapwindow, r"
            "SUPER SHIFT, UP, Swap window up, swapwindow, u"
            "SUPER SHIFT, DOWN, Swap window down, swapwindow, d"

            # Cycle through applications on active workspace
            "ALT, TAB, Cycle to next window, cyclenext"
            "ALT SHIFT, TAB, Cycle to prev window, cyclenext, prev"
            "ALT, TAB, Reveal active window on top, bringactivetotop"
            "ALT SHIFT, TAB, Reveal active window on top, bringactivetotop"

            # Resize active window
            "SUPER, code:20, Expand window left, resizeactive, -100 0    # - key"
            "SUPER, code:21, Shrink window left, resizeactive, 100 0     # = key"
            "SUPER SHIFT, code:20, Shrink window up, resizeactive, 0 -100"
            "SUPER SHIFT, code:21, Expand window down, resizeactive, 0 100"

            # Scroll through existing workspaces with SUPER + scroll
            "SUPER, mouse_down, Scroll active workspace forward, workspace, e+1"
            "SUPER, mouse_up, Scroll active workspace backward, workspace, e-1"

            # Toggle groups
            "SUPER, G, Toggle window grouping, togglegroup"
            "SUPER ALT, G, Move active window out of group, moveoutofgroup"

            # Join groups
            "SUPER ALT, LEFT, Move window to group on left, moveintogroup, l"
            "SUPER ALT, RIGHT, Move window to group on right, moveintogroup, r"
            "SUPER ALT, UP, Move window to group on top, moveintogroup, u"
            "SUPER ALT, DOWN, Move window to group on bottom, moveintogroup, d"

            # Navigate a single set of grouped windows
            "SUPER ALT, TAB, Next window in group, changegroupactive, f"
            "SUPER ALT SHIFT, TAB, Previous window in group, changegroupactive, b"

            # Scroll through a set of grouped windows with SUPER + ALT + scroll
            "SUPER ALT, mouse_down, Next window in group, changegroupactive, f"
            "SUPER ALT, mouse_up, Previous window in group, changegroupactive, b"

            # Activate window in a group by number
            "SUPER ALT, 1, Switch to group window 1, changegroupactive, 1"
            "SUPER ALT, 2, Switch to group window 2, changegroupactive, 2"
            "SUPER ALT, 3, Switch to group window 3, changegroupactive, 3"
            "SUPER ALT, 4, Switch to group window 4, changegroupactive, 4"
            "SUPER ALT, 5, Switch to group window 5, changegroupactive, 5"
            # Menus
            "SUPER, R, Launch apps, exec, omanix-launch-walker"
            "SUPER, SPACE, Launch apps, exec, hexecute"
            "SUPER CTRL, E, Emoji picker, exec, omanix-launch-walker -m symbols"
            "SUPER ALT, SPACE, Omarchy menu, exec, omanix-menu"
            "SUPER, ESCAPE, Power menu, exec, omanix-menu system"
            "SUPER, K, Show key bindings, exec, omanix-menu-keybindings"
            ", XF86Calculator, Calculator, exec, gnome-calculator"

            # Aesthetics
            "SUPER SHIFT, SPACE, Toggle top bar, exec, omarchy-toggle-waybar"
            "SUPER CTRL, SPACE, Next background in theme, exec, omarchy-theme-bg-next"
            "SUPER SHIFT CTRL, SPACE, Pick new theme, exec, omanix-menu theme"
            ''SUPER, BACKSPACE, Toggle window transparency, exec, hyprctl dispatch setprop "address:$(hyprctl activewindow -j | jq -r '.address')" opaque toggle''
            "SUPER SHIFT, BACKSPACE, Toggle workspace gaps, exec, omarchy-hyprland-workspace-toggle-gaps"

            # Notifications
            "SUPER, COMMA, Dismiss last notification, exec, makoctl dismiss"
            "SUPER SHIFT, COMMA, Dismiss all notifications, exec, makoctl dismiss --all"
            ''SUPER CTRL, COMMA, Toggle silencing notifications, exec, makoctl mode -t do-not-disturb && makoctl mode | grep -q 'do-not-disturb' && notify-send "Silenced notifications" || notify-send "Enabled notifications"''

            # Toggle idling
            "SUPER CTRL, I, Toggle locking on idle, exec, omarchy-toggle-idle"

            # Toggle nightlight
            "SUPER CTRL, N, Toggle nightlight, exec, omarchy-toggle-nightlight"

            # Control Apple Display brightness
            "CTRL, F1, Apple Display brightness down, exec, omarchy-cmd-apple-display-brightness -5000"
            "CTRL, F2, Apple Display brightness up, exec, omarchy-cmd-apple-display-brightness +5000"
            "SHIFT CTRL, F2, Apple Display full brightness, exec, omarchy-cmd-apple-display-brightness +60000"

            # Captures
            ", PRINT, Screenshot with Editing, exec, omarchy-cmd-screenshot"
            "SHIFT, PRINT, Screenshot to Clipboard, exec, omarchy-cmd-screenshot smart clipboard"
            "ALT, PRINT, Screenrecording, exec, omanix-menu screenrecord"
            "SUPER, PRINT, Color picking, exec, pkill hyprpicker || hyprpicker -a"

            # File sharing
            "SUPER CTRL, S, Share, exec, omanix-menu share"

            # Waybar-less information
            ''SUPER CTRL, T, Show time, exec, notify-send "    $(date +"%A %H:%M  —  %d %B W%V %Y")"''
            ''SUPER CTRL, B, Show battery remaining, exec, notify-send "󰁹    Battery is at $(omarchy-battery-remaining)%"''

            ''SUPER, RETURN, Terminal, exec, $terminal --working-directory="$(omanix-cmd-terminal-cwd)"''
            "SUPER SHIFT, F, File manager, exec, uwsm-app -- nautilus --new-window"
            "SUPER SHIFT, B, Browser, exec, $browser"
            "SUPER SHIFT ALT, B, Browser (private), exec, $browser --private"
            "SUPER SHIFT, M, Music, exec, omarchy-launch-or-focus spotify"
            "SUPER SHIFT, N, Editor, exec, omarchy-launch-editor"
            "SUPER SHIFT, T, Activity, exec, $terminal -e btop"
            "SUPER SHIFT, D, Docker, exec, $terminal -e lazydocker"
            ''SUPER SHIFT, G, Signal, exec, omarchy-launch-or-focus signal "uwsm-app -- signal-desktop"''
            ''SUPER SHIFT, O, Obsidian, exec, omarchy-launch-or-focus "^obsidian$" "uwsm-app -- obsidian -disable-gpu --enable-wayland-ime"''
            "SUPER SHIFT, W, Typora, exec, uwsm-app -- typora"
            "SUPER SHIFT, SLASH, Passwords, exec, uwsm-app -- 1password"

            # If your web app url contains #, type it as ## to prevent hyprland treating it as a comment
            ''SUPER SHIFT, A, ChatGPT, exec, omarchy-launch-webapp "https://chatgpt.com"''
            ''SUPER SHIFT ALT, A, Grok, exec, omarchy-launch-webapp "https://grok.com"''
            ''SUPER SHIFT, C, Calendar, exec, omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"''
            "SUPER SHIFT, E, Email, exec, uwsm-app -- thunderbird"
            ''SUPER SHIFT, Y, YouTube, exec, omarchy-launch-webapp "https://youtube.com/"''
            ''SUPER SHIFT ALT, G, WhatsApp, exec, omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"''
            ''SUPER SHIFT CTRL, G, Google Messages, exec, omarchy-launch-or-focus-webapp "Google Messages" "https://messages.google.com/web/conversations"''
            ''SUPER SHIFT, X, X, exec, omarchy-launch-webapp "https://x.com/"''
            ''SUPER SHIFT ALT, X, X Post, exec, omarchy-launch-webapp "https://x.com/compose/post"''

            "SUPER SHIFT, P, Switch monitors, exec, omanix-menu-monitors"
          ];
          # Only display the OSD on the currently focused monitor
          "$osdclient" =
            ''swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"'';
          bindeld = [
            # Laptop multimedia keys for volume and LCD brightness (with OSD)
            ",XF86AudioRaiseVolume, Volume up, exec, $osdclient --output-volume raise"
            ",XF86AudioLowerVolume, Volume down, exec, $osdclient --output-volume lower"
            ",XF86AudioMute, Mute, exec, $osdclient --output-volume mute-toggle"
            ",XF86AudioMicMute, Mute microphone, exec, $osdclient --input-volume mute-toggle"
            ",XF86MonBrightnessUp, Brightness up, exec, $osdclient --brightness raise"
            ",XF86MonBrightnessDown, Brightness down, exec, $osdclient --brightness lower"

            # Precise 1% multimedia adjustments with Alt modifier
            "ALT, XF86AudioRaiseVolume, Volume up precise, exec, $osdclient --output-volume +1"
            "ALT, XF86AudioLowerVolume, Volume down precise, exec, $osdclient --output-volume -1"
            "ALT, XF86MonBrightnessUp, Brightness up precise, exec, $osdclient --brightness +1"
            "ALT, XF86MonBrightnessDown, Brightness down precise, exec, $osdclient --brightness -1"
          ];
          bindld = [
            # Requires playerctl
            ", XF86AudioNext, Next track, exec, $osdclient --playerctl next"
            ", XF86AudioPause, Pause, exec, $osdclient --playerctl play-pause"
            ", XF86AudioPlay, Play, exec, $osdclient --playerctl play-pause"
            ", XF86AudioPrev, Previous track, exec, $osdclient --playerctl previous"

            # Switch audio output with Super + Mute
            "SUPER, XF86AudioMute, Switch audio output, exec, omarchy-cmd-audio-switch"
            ", XF86PowerOff, Power menu, exec, omanix-menu system"
          ];
          bindmd = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "SUPER, mouse:272, Move window, movewindow"
            "SUPER, mouse:273, Resize window, resizewindow"
          ];
          # Don't show update on first launch
          ecosystem.no_update_news = true;
          env = [
            # Cursor size
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"

            # Force all apps to use Wayland
            "GDK_BACKEND,wayland,x11,*"
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_STYLE_OVERRIDE,kvantum"
            "SDL_VIDEODRIVER,wayland"
            "MOZ_ENABLE_WAYLAND,1"
            "ELECTRON_OZONE_PLATFORM_HINT,wayland"
            "OZONE_PLATFORM,wayland"
            "XDG_SESSION_TYPE,wayland"

            # Allow better support for screen sharing (Google Meet, Discord, etc)
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_DESKTOP,Hyprland"

            # Use XCompose file
            "XCOMPOSEFILE,~/.XCompose"
          ];
          # Refer to https://wiki.hyprland.org/Configuring/Variables/

          exec-once = [
            "networkmanagerapplet"
          ];

          # Variables
          "$activeBorderColor" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "$inactiveBorderColor" = "rgba(595959aa)";

          # https://wiki.hyprland.org/Configuring/Variables/#general;
          general = {
            gaps_in = 5;
            gaps_out = 10;

            border_size = 2;

            # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors;
            "col.active_border" = "$activeBorderColor";
            "col.inactive_border" = "$inactiveBorderColor";

            # Set to true enable resizing windows by clicking and dragging on borders and gaps;
            resize_on_border = false;

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on;
            allow_tearing = false;

            layout = "dwindle";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#decoration;
          decoration = {
            rounding = 0;

            shadow = {
              enabled = true;
              range = 2;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };

            # https://wiki.hyprland.org/Configuring/Variables/#blur;
            blur = {
              enabled = true;
              size = 3;
              passes = 3;
            };
          };

          # https://wiki.hypr.land/Configuring/Variables/#group;
          group = {
            "col.border_active" = "$activeBorderColor";
            "col.border_inactive" = "$inactiveBorderColor";
            "col.border_locked_active" = -1;
            "col.border_locked_inactive" = -1;

            groupbar = {
              font_size = 12;
              font_family = "monospace";
              font_weight_active = "ultraheavy";
              font_weight_inactive = "normal";

              indicator_height = 0;
              indicator_gap = 5;
              height = 22;
              gaps_in = 5;
              gaps_out = 0;

              text_color = "rgb(ffffff)";
              text_color_inactive = "rgba(ffffff90)";
              "col.active" = "rgba(00000040)";
              "col.inactive" = "rgba(00000020)";

              gradients = true;
              gradient_rounding = 0;
              gradient_round_only_edges = false;
            };
          };

          # https://wiki.hyprland.org/Configuring/Variables/#animations;
          animations = {
            enabled = "yes, please :)";

            # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more;

            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];

            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 0, 0, ease"
            ];
          };

          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more;
          dwindle = {
            pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below;
            preserve_split = true; # You probably want this;
            force_split = 2; # Always split on the right;
          };

          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more;
          master = {
            new_status = "master";
          };

          # https://wiki.hyprland.org/Configuring/Variables/#misc;
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            focus_on_activate = true;
            anr_missed_pings = 3;
          };

          # https://wiki.hypr.land/Configuring/Variables/#cursor;
          cursor = {
            hide_on_key_press = true;
          };
          # https://wiki.hyprland.org/Configuring/Variables/#input
          input = {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "compose:caps";
            kb_rules = "";

            follow_mouse = 1;

            repeat_rate = 40;
            repeat_delay = 600;

            # -1.0 - 1.0, 0 means no modification.
            sensitivity = 0;

            touchpad = {
              natural_scroll = false;
              scroll_factor = 0.4;
            };
          };
          layerrule = [
            # Remove 1px border around hyprshot screenshots
            "noanim, selection"

            "noanim, walker"
          ];
          monitor = [
            "${config.ironman.monitor},highres,0x0,1"
            ",highres,0x1920,1"
          ];
          windowrule = [
            "fullscreen, class:Screensaver"
            # Browser types
            "tag +chromium-based-browser, class:((google-)?[cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable|helium)"
            "tag +firefox-based-browser, class:([fF]irefox|zen|librewolf)"

            "float, tag:chromium-based-browser, title:Bitwarden"

            # Force chromium-based browsers into a tile to deal with --app bug
            "tile, tag:chromium-based-browser"

            # Only a subtle opacity change, but not for video sites
            "opacity 1 0.97, tag:chromium-based-browser"
            "opacity 1 0.97, tag:firefox-based-browser"

            # Some video sites should never have opacity applied to them
            "opacity 1.0 1.0, initialTitle:((?i)(?:[a-z0-9-]+\.)*youtube\.com_/|app\.zoom\.us_/wc/home)"

            # Float LocalSend and fzf file picker
            "float, class:(Share|localsend)"
            "center, class:(Share|localsend)"

            # Picture-in-picture overlays
            "tag +pip, title:(Picture.{0,1}in.{0,1}[Pp]icture)"
            "float, tag:pip"
            "pin, tag:pip"
            "size 600 338, tag:pip"
            "keepaspectratio, tag:pip"
            "noborder, tag:pip"
            "opacity 1 1, tag:pip"
            "move 100%-w-40 4%, tag:pip"

            "opacity 1 1, class:qemu"

            # Float Steam
            "float, class:steam"
            "center, class:steam, title:Steam"
            "opacity 1 1, class:steam"
            "size 1100 700, class:steam, title:Steam"
            "size 460 800, class:steam, title:Friends List"
            "idleinhibit fullscreen, class:steam"

            # Floating windows
            "float, tag:floating-window"
            "center, tag:floating-window"
            "size 800 600, tag:floating-window"

            "tag +floating-window, class:(blueberry.py|Impala|Wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Omarchy|About|TUI.float)"
            "tag +floating-window, class:(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), title:^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)"
            "float, class:org.gnome.Calculator"

            # Fullscreen screensaver
            "fullscreen, class:Screensaver"

            # No transparency on media windows
            "opacity 1 1, class:^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"

            # Define terminal tag to style them uniformly
            "tag +terminal, class:(Alacritty|kitty|com.mitchellh.ghostty)"

            # Webcam overlay for screen recording
            "float, title:WebcamOverlay"
            "pin, title:WebcamOverlay"
            "noinitialfocus, title:WebcamOverlay"
            "nodim, title:WebcamOverlay"
            "move 100%-w-40 100%-w-40, title:WebcamOverlay # There's a typo in the hyprland rule so 100%-w on the height param is actually correct here"

            # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
            "suppressevent maximize, class:.*"

            # Just dash of opacity by default
            "opacity 0.97 0.9, class:.*"

            # Fix some dragging issues with XWayland
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

            "scrolltouchpad 1.5, class:(Alacritty|kitty)"
            "scrolltouchpad 0.2, class:com.mitchellh.ghostty"
          ];
          xwayland.force_zero_scaling = true;
        };
      };
      xdg = {
        configFile = {
          "omarchy/current/background".source = flakeRoot + "/.config/backgrounds/voidbringer.png";
          "hypr/omarchy-launch-floating-terminal-with-presentation".source =
            pkgs.writeShellScript "omarchy-launch-floating-terminal-with-presentation"
              (
                let
                  logo = pkgs.writeTextFile {
                    inherit (config.xdg.dataFile."omarchy/logo.txt") text;
                    name = "logo.txt";
                  };
                  omarchy-show-logo = pkgs.writeShellScript "omarchy-show-logo" ''
                    clear
                    echo -e "\033[32m"
                    cat <${logo}
                    echo -e "\033[0m"
                    echo
                  '';
                  omarchy-show-done = pkgs.writeShellScript "omarchy-show-done" ''
                    echo
                    ${pkgs.gum}/bin/gum spin --spinner "globe" --title "Done! Press any key to close..." -- bash -c 'read -n 1 -s'
                  '';
                in
                ''
                  cmd="$*"
                  exec setsid uwsm-app -- alacritty -o font.size=9 --class=Omarchy --title=Omarchy -e bash -c "${omarchy-show-logo}; $cmd; ${omarchy-show-done}"
                ''
              );
          "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
        };
        dataFile."omarchy/logo.txt".text = ''
                           ▄▄▄
           ▄█████▄    ▄███████████▄    ▄███████   ▄███████   ▄███████   ▄█   █▄    ▄█   █▄
          ███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
          ███   ███  ███   ███   ███  ███   ███  ███   ███  ███   █▀   ███   ███  ███   ███
          ███   ███  ███   ███   ███ ▄███▄▄▄███ ▄███▄▄▄██▀  ███       ▄███▄▄▄███▄ ███▄▄▄███
          ███   ███  ███   ███   ███ ▀███▀▀▀███ ▀███▀▀▀▀    ███      ▀▀███▀▀▀███  ▀▀▀▀▀▀███
          ███   ███  ███   ███   ███  ███   ███ ██████████  ███   █▄   ███   ███  ▄██   ███
          ███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
           ▀█████▀    ▀█   ███   █▀   ███   █▀   ███   ███  ███████▀   ███   █▀    ▀█████▀
                                                 ███   █▀
        '';
      };
    };
}
