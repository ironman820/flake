{ flakeRoot, ... }:
{
  flake.homeModules.hyprland-config =
    { config, pkgs, ... }:
    {
      home = {
        sessionVariables.NIXOS_OZONE_WL = "1";
      };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          bind = [
            "SUPER, Q, exec, kitty"
            "SUPER, W, killactive,"
            "SUPER, M, exit,"
            # ", Print, exec, grimblast copy area"
          ]
          ++ (
            # workspaces
            # binds SUPER + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "SUPER, code:1${toString i}, workspace, ${toString ws}"
                  "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            )
          );
          monitor = ",highres,0x0,1";
          source = [
            "${config.xdg.configHome}/hypr/autostart.conf"
          ];
          windowrule = [
            "fullscreen, class:Screensaver"
          ];
        };
      };
      xdg = {
        configFile = {
          "omarchy/current/background".source = flakeRoot + "/.config/backgrounds/voidbringer.png";
          "hypr/autostart.conf".text = ''
            exec-once = uwsm-app -- waybar
          '';
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
          "hypr/omarchy-launch-wifi".source = pkgs.writeShellScript "omarchy-launch-wifi" ''
            exec setsid uwsm-app -- "$TERMINAL" --class=Impala -e impala "$@"
          '';
          "hypr/omarchy-menu-keybindings".source = pkgs.writeShellScript "omarchy-menu-keybindings" ''
            # A script to display Hyprland keybindings defined in your configuration
            # using walker for an interactive search menu.

            declare -A KEYCODE_SYM_MAP

            build_keymap_cache() {
              local keymap
              keymap="$(xkbcli compile-keymap)" || {
                echo "Failed to compile keymap" >&2
                return 1
              }

              while IFS=, read -r code sym; do
                [[ -z "$code" || -z "$sym" ]] && continue
                KEYCODE_SYM_MAP["$code"]="$sym"
              done < <(
                awk '
                  BEGIN { sec = "" }
                  /xkb_keycodes/ { sec = "codes"; next }
                  /xkb_symbols/  { sec = "syms";  next }
                  sec == "codes" {
                    if (match($0, /<([A-Za-z0-9_]+)>\s*=\s*([0-9]+)\s*;/, m)) code_by_name[m[1]] = m[2]
                  }
                  sec == "syms" {
                    if (match($0, /key\s*<([A-Za-z0-9_]+)>\s*\{\s*\[\s*([^, \]]+)/, m)) sym_by_name[m[1]] = m[2]
                  }
                  END {
                    for (k in code_by_name) {
                      c = code_by_name[k]
                      s = sym_by_name[k]
                      if (c != "" && s != "" && s != "NoSymbol") print c "," s
                    }
                  }
                ' <<<"$keymap"
              )
            }

            lookup_keycode_cached() {
              printf '%s\n' "''${KEYCODE_SYM_MAP[$1]}"
            }

            parse_keycodes() {
              local start end elapsed
              [[ "''${DEBUG:-0}" == "1" ]] && start=$(date +%s.%N)
              while IFS= read -r line; do
                if [[ "$line" =~ code:([0-9]+) ]]; then
                  code="''${BASH_REMATCH[1]}"
                  symbol=$(lookup_keycode_cached "$code" "$XKB_KEYMAP_CACHE")
                  echo "''${line/code:''${code}/$symbol}"
                else
                  echo "$line"
                fi
              done

              if [[ "$DEBUG" == "1" ]]; then
                end=$(date +%s.%N)
                # fall back to awk if bc is missing
                if command -v bc >/dev/null 2>&1; then
                  elapsed=$(echo "$end - $start" | bc)
                else
                  elapsed=$(awk -v s="$start" -v e="$end" 'BEGIN{printf "%.6f", (e - s)}')
                fi
                echo "[DEBUG] parse_keycodes elapsed: ''${elapsed}s" >&2
              fi
            }

            # Fetch dynamic keybindings from Hyprland
            #
            # Also do some pre-processing:
            # - Remove standard Omarchy bin path prefix
            # - Remove uwsm prefix
            # - Map numeric modifier key mask to a textual rendition
            # - Output comma-separated values that the parser can understand
            dynamic_bindings() {
              hyprctl -j binds |
                jq -r '.[] | {modmask, key, keycode, description, dispatcher, arg} | "\(.modmask),\(.key)@\(.keycode),\(.description),\(.dispatcher),\(.arg)"' |
                sed -r \
                  -e 's/null//' \
                  -e 's,~/.local/share/omarchy/bin/,,' \
                  -e 's,uwsm app -- ,,' \
                  -e 's,uwsm-app -- ,,' \
                  -e 's/@0//' \
                  -e 's/,@/,code:/' \
                  -e 's/^0,/,/' \
                  -e 's/^1,/SHIFT,/' \
                  -e 's/^4,/CTRL,/' \
                  -e 's/^5,/SHIFT CTRL,/' \
                  -e 's/^8,/ALT,/' \
                  -e 's/^9,/SHIFT ALT,/' \
                  -e 's/^12,/CTRL ALT,/' \
                  -e 's/^13,/SHIFT CTRL ALT,/' \
                  -e 's/^64,/SUPER,/' \
                  -e 's/^65,/SUPER SHIFT,/' \
                  -e 's/^68,/SUPER CTRL,/' \
                  -e 's/^69,/SUPER SHIFT CTRL,/' \
                  -e 's/^72,/SUPER ALT,/' \
                  -e 's/^73,/SUPER SHIFT ALT,/' \
                  -e 's/^76,/SUPER CTRL ALT,/' \
                  -e 's/^77,/SUPER SHIFT CTRL ALT,/'
            }

            # Parse and format keybindings
            #
            # `awk` does the heavy lifting:
            # - Set the field separator to a comma ','.
            # - Joins the key combination (e.g., "SUPER + Q").
            # - Joins the command that the key executes.
            # - Prints everything in a nicely aligned format.
            parse_bindings() {
              awk -F, '
            {
                # Combine the modifier and key (first two fields)
                key_combo = $1 " + " $2;

                # Clean up: strip leading "+" if present, trim spaces
                gsub(/^[ \t]*\+?[ \t]*/, "", key_combo);
                gsub(/[ \t]+$/, "", key_combo);

                # Use description, if set
                action = $3;

                if (action == "") {
                    # Reconstruct the command from the remaining fields
                    for (i = 4; i <= NF; i++) {
                        action = action $i (i < NF ? "," : "");
                    }

                    # Clean up trailing commas, remove leading "exec, ", and trim
                    sub(/,$/, "", action);
                    gsub(/(^|,)[[:space:]]*exec[[:space:]]*,?/, "", action);
                    gsub(/^[ \t]+|[ \t]+$/, "", action);
                    gsub(/[ \t]+/, " ", key_combo);  # Collapse multiple spaces to one

                    # Escape XML entities
                    gsub(/&/, "\\&amp;", action);
                    gsub(/</, "\\&lt;", action);
                    gsub(/>/, "\\&gt;", action);
                    gsub(/"/, "\\&quot;", action);
                    gsub(/'"'"'/, "\\&apos;", action);
                }

                if (action != "") {
                    printf "%-35s → %s\n", key_combo, action;
                }
            }'
            }

            monitor_height=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .height')
            menu_height=$((monitor_height * 40 / 100))

            build_keymap_cache

            dynamic_bindings |
              sort -u |
              parse_keycodes |
              parse_bindings |
              ${pkgs.walker}/bin/walker --dmenu -p 'Keybindings' --width 800 --height "$menu_height"
          '';
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
