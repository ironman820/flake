{
  flake.homeModules.omanix =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (writeShellScriptBin "omanix-menu" ''
          # Set to true when going directly to a submenu, so we can exit directly
          BACK_TO_EXIT=false

          back_to() {
            local parent_menu="$1"

            if [[ "$BACK_TO_EXIT" == "true" ]]; then
              exit 0
            elif [[ -n "$parent_menu" ]]; then
              "$parent_menu"
            else
              show_main_menu
            fi
          }

          menu() {
            local prompt="$1"
            local options="$2"
            local extra="$3"
            local preselect="$4"

            read -r -a args <<<"$extra"

            if [[ -n "$preselect" ]]; then
              local index
              index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
              if [[ -n "$index" ]]; then
                args+=("-c" "$index")
              fi
            fi

            echo -e "$options" | omarchy-launch-walker --dmenu --width 295 --minheight 1 --maxheight 600 -p "$prompt…" "''${args[@]}" 2>/dev/null
          }

          terminal() {
            alacritty --class=Omarchy -e "$@"
          }

          present_terminal() {
            omarchy-launch-floating-terminal-with-presentation $1
          }

          open_in_editor() {
            notify-send "Editing config file" "$1"
            omarchy-launch-editor "$1"
          }

          install() {
            present_terminal "echo 'Installing $1...'; sudo pacman -S --noconfirm $2"
          }

          install_and_launch() {
            present_terminal "echo 'Installing $1...'; sudo pacman -S --noconfirm $2 && setsid gtk-launch $3"
          }

          install_font() {
            present_terminal "echo 'Installing $1...'; sudo pacman -S --noconfirm --needed $2 && sleep 2 && omarchy-font-set '$3'"
          }

          install_terminal() {
            present_terminal "omarchy-install-terminal $1"
          }

          aur_install() {
            present_terminal "echo 'Installing $1 from AUR...'; yay -S --noconfirm $2"
          }

          aur_install_and_launch() {
            present_terminal "echo 'Installing $1 from AUR...'; yay -S --noconfirm $2 && setsid gtk-launch $3"
          }

          show_learn_menu() {
            case $(menu "Learn" "  Keybindings\n  Omarchy\n  Hyprland\n󰣇  Arch\n  Neovim\n󱆃  Bash") in
            *Keybindings*) omarchy-menu-keybindings ;;
            *Omarchy*) omarchy-launch-webapp "https://learn.omacom.io/2/the-omarchy-manual" ;;
            *Hyprland*) omarchy-launch-webapp "https://wiki.hypr.land/" ;;
            *Arch*) omarchy-launch-webapp "https://wiki.archlinux.org/title/Main_page" ;;
            *Bash*) omarchy-launch-webapp "https://devhints.io/bash" ;;
            *Neovim*) omarchy-launch-webapp "https://www.lazyvim.org/keymaps" ;;
            *) show_main_menu ;;
            esac
          }

          show_trigger_menu() {
            case $(menu "Trigger" "  Capture\n  Share\n󰔎  Toggle") in
            *Capture*) show_capture_menu ;;
            *Share*) show_share_menu ;;
            *Toggle*) show_toggle_menu ;;
            *) show_main_menu ;;
            esac
          }

          show_capture_menu() {
            case $(menu "Capture" "  Screenshot\n  Screenrecord\n󰃉  Color") in
            *Screenshot*) show_screenshot_menu ;;
            *Screenrecord*) show_screenrecord_menu ;;
            *Color*) pkill hyprpicker || hyprpicker -a ;;
            *) show_trigger_menu ;;
            esac
          }

          show_screenshot_menu() {
            case $(menu "Screenshot" "  Snap with Editing\n  Straight to Clipboard") in
            *Editing*) omarchy-cmd-screenshot smart ;;
            *Clipboard*) omarchy-cmd-screenshot smart clipboard ;;
            *) show_capture_menu ;;
            esac
          }

          show_screenrecord_menu() {
            case $(menu "Screenrecord" "  Region\n  Region + Audio\n  Display\n  Display + Audio\n  Display + Webcam") in
            *"Region + Audio"*) omarchy-cmd-screenrecord region --with-audio ;;
            *Region*) omarchy-cmd-screenrecord ;;
            *"Display + Audio"*) omarchy-cmd-screenrecord output --with-audio ;;
            *"Display + Webcam"*) omarchy-cmd-screenrecord output --with-audio --with-webcam ;;
            *Display*) omarchy-cmd-screenrecord output ;;
            *) back_to show_capture_menu ;;
            esac
          }

          show_share_menu() {
            case $(menu "Share" "  Clipboard\n  File \n  Folder") in
            *Clipboard*) terminal bash -c "omarchy-cmd-share clipboard" ;;
            *File*) terminal bash -c "omarchy-cmd-share file" ;;
            *Folder*) terminal bash -c "omarchy-cmd-share folder" ;;
            *) back_to show_trigger_menu ;;
            esac
          }

          show_toggle_menu() {
            case $(menu "Toggle" "󱄄  Screensaver\n󰔎  Nightlight\n󱫖  Idle Lock\n󰍜  Top Bar") in
            *Screensaver*) omarchy-toggle-screensaver ;;
            *Nightlight*) omarchy-toggle-nightlight ;;
            *Idle*) omarchy-toggle-idle ;;
            *Bar*) omarchy-toggle-waybar ;;
            *) show_trigger_menu ;;
            esac
          }

          show_style_menu() {
            case $(menu "Style" "󰸌  Theme\n  Font\n  Background\n  Hyprland\n󱄄  Screensaver\n  About") in
            *Theme*) show_theme_menu ;;
            *Font*) show_font_menu ;;
            *Background*) omarchy-theme-bg-next ;;
            *Hyprland*) open_in_editor ~/.config/hypr/looknfeel.conf ;;
            *Screensaver*) open_in_editor ~/.config/omarchy/branding/screensaver.txt ;;
            *About*) open_in_editor ~/.config/omarchy/branding/about.txt ;;
            *) show_main_menu ;;
            esac
          }

          show_theme_menu() {
            theme=$(menu "Theme" "$(omarchy-theme-list)" "" "$(omarchy-theme-current)")
            if [[ "$theme" == "CNCLD" || -z "$theme" ]]; then
              back_to show_style_menu
            else
              omarchy-theme-set "$theme"
            fi
          }

          show_font_menu() {
            theme=$(menu "Font" "$(omarchy-font-list)" "--width 350" "$(omarchy-font-current)")
            if [[ "$theme" == "CNCLD" || -z "$theme" ]]; then
              back_to show_style_menu
            else
              omarchy-font-set "$theme"
            fi
          }

          show_setup_menu() {
            local options="  Audio\n  Wifi\n󰂯  Bluetooth\n󱐋  Power Profile\n󰍹  Monitors"
            [ -f ~/.config/hypr/bindings.conf ] && options="$options\n  Keybindings"
            [ -f ~/.config/hypr/input.conf ] && options="$options\n  Input"
            options="$options\n  Defaults\n󰱔  DNS\n  Security\n  Config"

            case $(menu "Setup" "$options") in
            *Audio*) $TERMINAL --class=Wiremix -e wiremix ;;
            *Wifi*)
              rfkill unblock wifi
              omarchy-launch-wifi
              ;;
            *Bluetooth*)
              rfkill unblock bluetooth
              blueberry
              ;;
            *Power*) show_setup_power_menu ;;
            *Monitors*) open_in_editor ~/.config/hypr/monitors.conf ;;
            *Keybindings*) open_in_editor ~/.config/hypr/bindings.conf ;;
            *Input*) open_in_editor ~/.config/hypr/input.conf ;;
            *Defaults*) open_in_editor ~/.config/uwsm/default ;;
            *DNS*) present_terminal omarchy-setup-dns ;;
            *Security*) show_setup_security_menu ;;
            *Config*) show_setup_config_menu ;;
            *) show_main_menu ;;
            esac
          }

          show_setup_power_menu() {
            profile=$(menu "Power Profile" "$(omarchy-powerprofiles-list)" "" "$(powerprofilesctl get)")

            if [[ "$profile" == "CNCLD" || -z "$profile" ]]; then
              back_to show_setup_menu
            else
              powerprofilesctl set "$profile"
            fi
          }

          show_setup_config_menu() {
            case $(menu "Setup" "  Hyprland\n  Hypridle\n  Hyprlock\n  Hyprsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar\n󰞅  XCompose") in
            *Hyprland*) open_in_editor ~/.config/hypr/hyprland.conf ;;
            *Hypridle*) open_in_editor ~/.config/hypr/hypridle.conf && omarchy-restart-hypridle ;;
            *Hyprlock*) open_in_editor ~/.config/hypr/hyprlock.conf ;;
            *Hyprsunset*) open_in_editor ~/.config/hypr/hyprsunset.conf && omarchy-restart-hyprsunset ;;
            *Swayosd*) open_in_editor ~/.config/swayosd/config.toml && omarchy-restart-swayosd ;;
            *Walker*) open_in_editor ~/.config/walker/config.toml && omarchy-restart-walker ;;
            *Waybar*) open_in_editor ~/.config/waybar/config.jsonc && omarchy-restart-waybar ;;
            *XCompose*) open_in_editor ~/.XCompose && omarchy-restart-xcompose ;;
            *) show_main_menu ;;
            esac
          }

          show_setup_security_menu() {
            case $(menu "Setup" "󰈷  Fingerprint\n  Fido2") in
            *Fingerprint*) present_terminal omarchy-setup-fingerprint ;;
            *Fido2*) present_terminal omarchy-setup-fido2 ;;
            *) show_setup_menu ;;
            esac
          }

          show_install_menu() {
            case $(menu "Install" "󰣇  Package\n󰣇  AUR\n  Web App\n  TUI\n  Service\n  Style\n󰵮  Development\n  Editor\n  Terminal\n󱚤  AI\n󰍲  Windows\n  Gaming") in
            *Package*) terminal omarchy-pkg-install ;;
            *AUR*) terminal omarchy-pkg-aur-install ;;
            *Web*) present_terminal omarchy-webapp-install ;;
            *TUI*) present_terminal omarchy-tui-install ;;
            *Service*) show_install_service_menu ;;
            *Style*) show_install_style_menu ;;
            *Development*) show_install_development_menu ;;
            *Editor*) show_install_editor_menu ;;
            *Terminal*) show_install_terminal_menu ;;
            *AI*) show_install_ai_menu ;;
            *Windows*) present_terminal "omarchy-windows-vm install" ;;
            *Gaming*) show_install_gaming_menu ;;
            *) show_main_menu ;;
            esac
          }

          show_install_service_menu() {
            case $(menu "Install" "  Dropbox\n  Tailscale\n󰟵  Bitwarden\n  Chromium Account") in
            *Dropbox*) present_terminal omarchy-install-dropbox ;;
            *Tailscale*) present_terminal omarchy-install-tailscale ;;
            *Bitwarden*) install_and_launch "Bitwarden" "bitwarden bitwarden-cli" "bitwarden" ;;
            *Chromium*) present_terminal omarchy-install-chromium-google-account ;;
            *) show_install_menu ;;
            esac
          }

          show_install_editor_menu() {
            case $(menu "Install" "  VSCode\n  Cursor\n  Zed\n  Sublime Text\n  Helix\n  Emacs") in
            *VSCode*) present_terminal omarchy-install-vscode ;;
            *Cursor*) install_and_launch "Cursor" "cursor-bin" "cursor" ;;
            *Zed*) install_and_launch "Zed" "zed" "dev.zed.Zed" ;;
            *Sublime*) aur_install_and_launch "Sublime Text" "sublime-text-4" "sublime_text" ;;
            *Helix*) install "Helix" "helix" ;;
            *Emacs*) install "Emacs" "emacs-wayland" && systemctl --user enable --now emacs.service ;;
            *) show_install_menu ;;
            esac
          }

          show_install_terminal_menu() {
            case $(menu "Install" "  Alacritty\n  Ghostty\n  Kitty") in
            *Alacritty*) install_terminal "alacritty" ;;
            *Ghostty*) install_terminal "ghostty" ;;
            *Kitty*) install_terminal "kitty" ;;
            *) show_install_menu ;;
            esac
          }

          show_install_ai_menu() {
            ollama_pkg=$(
              (command -v nvidia-smi &>/dev/null && echo ollama-cuda) ||
                (command -v rocminfo &>/dev/null && echo ollama-rocm) ||
                echo ollama
            )

            case $(menu "Install" "󱚤  Claude Code\n󱚤  Cursor CLI [AUR]\n󱚤  Gemini [AUR]\n󱚤  OpenAI Codex [AUR]\n󱚤  LM Studio\n󱚤  Ollama\n󱚤  Crush\n󱚤  opencode") in
            *Claude*) install "Claude Code" "claude-code" ;;
            *Cursor*) aur_install "Cursor CLI" "cursor-cli" ;;
            *OpenAI*) aur_install "OpenAI Codex" "openai-codex-bin" ;;
            *Gemini*) aur_install "Gemini" "gemini-cli" ;;
            *Studio*) install "LM Studio" "lmstudio" ;;
            *Ollama*) install "Ollama" $ollama_pkg ;;
            *Crush*) install "Crush" "crush-bin" ;;
            *opencode*) install "opencode" "opencode" ;;
            *) show_install_menu ;;
            esac
          }

          show_install_gaming_menu() {
            case $(menu "Install" "  Steam\n  RetroArch [AUR]\n󰍳  Minecraft") in
            *Steam*) present_terminal omarchy-install-steam ;;
            *RetroArch*) aur_install_and_launch "RetroArch" "retroarch retroarch-assets libretro libretro-fbneo" "com.libretro.RetroArch.desktop" ;;
            *Minecraft*) aur_install_and_launch "Minecraft [AUR]" "minecraft-launcher" "minecraft-launcher" ;;
            *) show_install_menu ;;
            esac
          }

          show_install_style_menu() {
            case $(menu "Install" "󰸌  Theme\n  Background\n  Font") in
            *Theme*) present_terminal omarchy-theme-install ;;
            *Background*) nautilus ~/.config/omarchy/current/theme/backgrounds ;;
            *Font*) show_install_font_menu ;;
            *) show_install_menu ;;
            esac
          }

          show_install_font_menu() {
            case $(menu "Install" "  Meslo LG Mono\n  Fira Code\n  Victor Code\n  Bistream Vera Mono" "--width 350") in
            *Meslo*) install_font "Meslo LG Mono" "ttf-meslo-nerd" "MesloLGL Nerd Font" ;;
            *Fira*) install_font "Fira Code" "ttf-firacode-nerd" "FiraCode Nerd Font" ;;
            *Victor*) install_font "Victor Code" "ttf-victor-mono-nerd" "VictorMono Nerd Font" ;;
            *Bistream*) install_font "Bistream Vera Code" "ttf-bitstream-vera-mono-nerd" "BitstromWera Nerd Font" ;;
            *) show_install_menu ;;
            esac
          }

          show_install_development_menu() {
            case $(menu "Install" "󰫏  Ruby on Rails\n  Docker DB\n  JavaScript\n  Go\n  PHP\n  Python\n  Elixir\n  Zig\n  Rust\n  Java\n  .NET\n  OCaml\n  Clojure") in
            *Rails*) present_terminal "omarchy-install-dev-env ruby" ;;
            *Docker*) present_terminal omarchy-install-docker-dbs ;;
            *JavaScript*) show_install_javascript_menu ;;
            *Go*) present_terminal "omarchy-install-dev-env go" ;;
            *PHP*) show_install_php_menu ;;
            *Python*) present_terminal "omarchy-install-dev-env python" ;;
            *Elixir*) show_install_elixir_menu ;;
            *Zig*) present_terminal "omarchy-install-dev-env zig" ;;
            *Rust*) present_terminal "omarchy-install-dev-env rust" ;;
            *Java*) present_terminal "omarchy-install-dev-env java" ;;
            *NET*) present_terminal "omarchy-install-dev-env dotnet" ;;
            *OCaml*) present_terminal "omarchy-install-dev-env ocaml" ;;
            *Clojure*) present_terminal "omarchy-install-dev-env clojure" ;;
            *) show_install_menu ;;
            esac
          }

          show_install_javascript_menu() {
            case $(menu "Install" "  Node.js\n  Bun\n  Deno") in
            *Node*) present_terminal "omarchy-install-dev-env node" ;;
            *Bun*) present_terminal "omarchy-install-dev-env bun" ;;
            *Deno*) present_terminal "omarchy-install-dev-env deno" ;;
            *) show_install_development_menu ;;
            esac
          }

          show_install_php_menu() {
            case $(menu "Install" "  PHP\n  Laravel\n  Symfony") in
            *PHP*) present_terminal "omarchy-install-dev-env php" ;;
            *Laravel*) present_terminal "omarchy-install-dev-env laravel" ;;
            *Symfony*) present_terminal "omarchy-install-dev-env symfony" ;;
            *) show_install_development_menu ;;
            esac
          }

          show_install_elixir_menu() {
            case $(menu "Install" "  Elixir\n  Phoenix") in
            *Elixir*) present_terminal "omarchy-install-dev-env elixir" ;;
            *Phoenix*) present_terminal "omarchy-install-dev-env phoenix" ;;
            *) show_install_development_menu ;;
            esac
          }

          show_remove_menu() {
            case $(menu "Remove" "󰣇  Package\n  Web App\n  TUI\n󰸌  Theme\n󰍲  Windows\n󰈷  Fingerprint\n  Fido2") in
            *Package*) terminal omarchy-pkg-remove ;;
            *Web*) present_terminal omarchy-webapp-remove ;;
            *TUI*) present_terminal omarchy-tui-remove ;;
            *Theme*) present_terminal omarchy-theme-remove ;;
            *Windows*) present_terminal "omarchy-windows-vm remove" ;;
            *Fingerprint*) present_terminal "omarchy-setup-fingerprint --remove" ;;
            *Fido2*) present_terminal "omarchy-setup-fido2 --remove" ;;
            *) show_main_menu ;;
            esac
          }

          show_update_menu() {
            case $(menu "Update" " Omarchy\n  Config\n󰸌  Extra Themes\n  Process\n󰇅  Hardware\n  Firmware\n  Password\n  Timezone\n  Time") in
            *Omarchy*) present_terminal omarchy-update ;;
            *Config*) show_update_config_menu ;;
            *Themes*) present_terminal omarchy-theme-update ;;
            *Process*) show_update_process_menu ;;
            *Hardware*) show_update_hardware_menu ;;
            *Firmware*) present_terminal omarchy-update-firmware ;;
            *Timezone*) present_terminal omarchy-tz-select ;;
            *Time*) present_terminal omarchy-reset-time ;;
            *Password*) show_update_password_menu ;;
            *) show_main_menu ;;
            esac
          }

          show_update_process_menu() {
            case $(menu "Restart" "  Hypridle\n  Hyprsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
            *Hypridle*) omarchy-restart-hypridle ;;
            *Hyprsunset*) omarchy-restart-hyprsunset ;;
            *Swayosd*) omarchy-restart-swayosd ;;
            *Walker*) omarchy-restart-walker ;;
            *Waybar*) omarchy-restart-waybar ;;
            *) show_update_menu ;;
            esac
          }

          show_update_config_menu() {
            case $(menu "Use default config" "  Hyprland\n  Hypridle\n  Hyprlock\n  Hyprsunset\n󱣴  Plymouth\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
            *Hyprland*) present_terminal omarchy-refresh-hyprland ;;
            *Hypridle*) present_terminal omarchy-refresh-hypridle ;;
            *Hyprlock*) present_terminal omarchy-refresh-hyprlock ;;
            *Hyprsunset*) present_terminal omarchy-refresh-hyprsunset ;;
            *Plymouth*) present_terminal omarchy-refresh-plymouth ;;
            *Swayosd*) present_terminal omarchy-refresh-swayosd ;;
            *Walker*) present_terminal omarchy-refresh-walker ;;
            *Waybar*) present_terminal omarchy-refresh-waybar ;;
            *) show_update_menu ;;
            esac
          }

          show_update_hardware_menu() {
            case $(menu "Restart" "  Audio\n󱚾  Wi-Fi\n󰂯  Bluetooth") in
            *Audio*) present_terminal omarchy-restart-pipewire ;;
            *Wi-Fi*) present_terminal omarchy-restart-wifi ;;
            *Bluetooth*) present_terminal omarchy-restart-bluetooth ;;
            *) show_update_menu ;;
            esac
          }

          show_update_password_menu() {
            case $(menu "Update Password" "  Drive Encryption\n  User") in
            *Drive*) present_terminal omarchy-drive-set-password ;;
            *User*) present_terminal passwd ;;
            *) show_update_menu ;;
            esac
          }

          show_system_menu() {
            case $(menu "System" "  Lock\n󱄄  Screensaver\n󰤄  Suspend\n󰜉  Restart\n󰐥  Shutdown") in
            *Lock*) omarchy-lock-screen ;;
            *Screensaver*) omarchy-launch-screensaver force ;;
            *Suspend*) systemctl suspend ;;
            *Restart*) omarchy-state clear re*-required && systemctl reboot --no-wall ;;
            *Shutdown*) omarchy-state clear re*-required && systemctl poweroff --no-wall ;;
            *) back_to show_main_menu ;;
            esac
          }

          show_main_menu() {
            go_to_menu "$(menu "Go" "󰀻  Apps\n󰧑  Learn\n󱓞  Trigger\n  Style\n  Setup\n󰉉  Install\n󰭌  Remove\n  Update\n  About\n  System")"
          }

          go_to_menu() {
            case "''${1,,}" in
            *apps*) walker -p "Launch…" ;;
            *learn*) show_learn_menu ;;
            *trigger*) show_trigger_menu ;;
            *share*) show_share_menu ;;
            *style*) show_style_menu ;;
            *theme*) show_theme_menu ;;
            *screenshot*) show_screenshot_menu ;;
            *screenrecord*) show_screenrecord_menu ;;
            *setup*) show_setup_menu ;;
            *power*) show_setup_power_menu ;;
            *install*) show_install_menu ;;
            *remove*) show_remove_menu ;;
            *update*) show_update_menu ;;
            *about*) omarchy-launch-about ;;
            *system*) show_system_menu ;;
            esac
          }

          if [[ -n "$1" ]]; then
            BACK_TO_EXIT=true
            go_to_menu "$1"
          else
            show_main_menu
          fi
        '')
      ];
    };
}
