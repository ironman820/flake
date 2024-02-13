{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) int lines str;
  inherit (pkgs) writeShellScript;

  cfg = config.ironman.home.tmux;
in {
  options.ironman.home.tmux = {
    enable = mkBoolOpt true "Setup tmux";
    baseIndex = mkOpt int 1 "Base number for windows";
    clock24 = mkBoolOpt true "Use a 24 hour clock";
    customPaneNavigationAndResize = mkBoolOpt true "Use hjkl for navigation";
    escapeTime = mkOpt int 0 "Escape time";
    extraConfig = mkOpt lines "" "Extra configuration options";
    historyLimit =
      mkOpt int 1000000 "The number of lines to keep in scrollback history";
    keyMode = mkOpt str "vi" "Key style used for control";
    secureSocket = mkBoolOpt false "Use a secure socket to connect.";
    shortcut =
      mkOpt str "Space" "Default leader key that will be paired with <Ctrl>";
    terminal = mkOpt str "screen-256color" "Default terminal config";
  };

  config = mkIf cfg.enable {
    ironman.home.tmux = {
      extraConfig = ''
        source-file ~/.config/tmux/tmux.reset.conf
        set-option -g terminal-overrides ',xterm-256color:RGB'

        set -g detach-on-destroy off
        set -g renumber-windows on
        set -g set-clipboard on
        set -g status-position top

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        set-option -sa terminal-features ',xterm-kitty:RGB'
        bind-key -T prefix g display-popup -E -w 95% -h 95% -d '#{pane_current_path}' lazygit
      '';
    };
    home.packages = with pkgs.ironman; [t];
    programs = {
      bash.bashrcExtra = ''
        if [[ -z "$TMUX" ]]; then
            ${pkgs.ironman.t}/bin/t $PWD
        fi
      '';
      tmux = {
        inherit
          (cfg)
          baseIndex
          clock24
          customPaneNavigationAndResize
          escapeTime
          extraConfig
          historyLimit
          keyMode
          secureSocket
          shortcut
          terminal
          ;
        enable = true;
        plugins = with pkgs.tmuxPlugins; [
          {
            plugin = catppuccin-tmux;
            extraConfig = ''
              set -g @catppuccin_window_left_separator ""
              set -g @catppuccin_window_right_separator " "
              set -g @catppuccin_window_middle_separator " █"
              set -g @catppuccin_window_number_position "right"
              set -g @catppuccin_window_default_fill "number"
              set -g @catppuccin_window_default_text "#W"
              set -g @catppuccin_window_current_fill "number"
              set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
              set -g @catppuccin_status_modules_right "session meetings date_time"
              set -g @catppuccin_status_left_separator  " "
              set -g @catppuccin_status_right_separator " "
              set -g @catppuccin_status_right_separator_inverse "no"
              set -g @catppuccin_status_fill "icon"
              set -g @catppuccin_status_connect_separator "no"
              set -g @catppuccin_date_time_text "%H:%M"
              set -g @catppuccin_meetings_text ""
            '';
          }
          cheat-sh
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
            '';
          }
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-strategy-nvim 'session'
            '';
          }
          sensible
          yank
          {
            plugin = tmux-fzf-url;
            extraConfig = ''
              set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
              set -g @fzf-url-history-limit '2000'
            '';
          }
          tmux-session-wizard
        ];
      };
    };
    xdg.configFile = {
      "tmux/cal.sh".source = writeShellScript "cal.sh" ''
        #!/bin/bash

        ALERT_IF_IN_NEXT_MINUTES=10
        ALERT_POPUP_BEFORE_SECONDS=10
        NERD_FONT_FREE="󱁕 "
        NERD_FONT_MEETING="󰤙 "

        get_attendees() {
          attendees=$(
          icalBuddy \
            --includeEventProps "attendees" \
            --propertyOrder "datetime,title" \
            --noCalendarNames \
            --dateFormat "%A" \
            --includeOnlyEventsFromNowOn \
            --limitItems 1 \
            --excludeAllDayEvents \
            --separateByDate \
            --excludeEndDates \
            --bullet "" \
            --excludeCals "training,omerxx@gmail.com" \
            eventsToday)
        }

        parse_attendees() {
          attendees_array=()
          for line in $attendees; do
            attendees_array+=("$line")
          done
          number_of_attendees=$((''${#attendees_array[@]}-3))
        }

        get_next_meeting() {
          next_meeting=$(icalBuddy \
            --includeEventProps "title,datetime" \
            --propertyOrder "datetime,title" \
            --noCalendarNames \
            --dateFormat "%A" \
            --includeOnlyEventsFromNowOn \
            --limitItems 1 \
            --excludeAllDayEvents \
            --separateByDate \
            --bullet "" \
            --excludeCals "training,omerxx@gmail.com" \
            eventsToday)
        }

        get_next_next_meeting() {
          end_timestamp=$(date +"%Y-%m-%d ''${end_time}:01 %z")
          tonight=$(date +"%Y-%m-%d 23:59:00 %z")
          next_next_meeting=$(
          icalBuddy \
            --includeEventProps "title,datetime" \
            --propertyOrder "datetime,title" \
            --noCalendarNames \
            --dateFormat "%A" \
            --limitItems 1 \
            --excludeAllDayEvents \
            --separateByDate \
            --bullet "" \
            --excludeCals "training,omerxx@gmail.com" \
            eventsFrom:"''${end_timestamp}" to:"''${tonight}")
        }

        parse_result() {
          array=()
          for line in $1; do
            array+=("$line")
          done
          time="''${array[2]}"
          end_time="''${array[4]}"
          title="''${array[*]:5:30}"
        }

        calculate_times(){
          epoc_meeting=$(date -j -f "%T" "$time:00" +%s)
          epoc_now=$(date +%s)
          epoc_diff=$((epoc_meeting - epoc_now))
          minutes_till_meeting=$((epoc_diff/60))
        }

        display_popup() {
          tmux display-popup \
            -S "fg=#eba0ac" \
            -w50% \
            -h50% \
            -d '#{pane_current_path}' \
            -T meeting \
            icalBuddy \
              --propertyOrder "datetime,title" \
              --noCalendarNames \
              --formatOutput \
              --includeEventProps "title,datetime,notes,url,attendees" \
              --includeOnlyEventsFromNowOn \
              --limitItems 1 \
              --excludeAllDayEvents \
              --excludeCals "training" \
              eventsToday
        }

        print_tmux_status() {
          if [[ $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES \
            && $minutes_till_meeting -gt -60 ]]; then
            echo "$NERD_FONT_MEETING \
              $time $title ($minutes_till_meeting minutes)"
          else
            echo "$NERD_FONT_FREE"
          fi

          if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS && epoc_diff -lt $ALERT_POPUP_BEFORE_SECONDS+10 ]]; then
            display_popup
          fi
        }

        main() {
          get_attendees
          parse_attendees
          get_next_meeting
          parse_result "$next_meeting"
          calculate_times
          if [[ "$next_meeting" != "" && $number_of_attendees -lt 2 ]]; then
            get_next_next_meeting
            parse_result "$next_next_meeting"
            calculate_times
          fi
          print_tmux_status
          # echo "$minutes_till_meeting | $number_of_attendees"
        }

        main
      '';
      "tmux/tmux.reset.conf".text = ''
        # First remove *all* keybindings
        # unbind-key -a
        # Now reinsert all the regular tmux keys
        # bind ^X lock-server
        bind C-c new-window
        bind C-d detach
        # bind * list-clients

        bind H previous-window
        bind L next-window

        # bind r command-prompt "rename-window %%"
        # bind R source-file ~/.config/tmux/tmux.conf
        # bind ^A last-window
        # bind ^W list-windows
        bind w list-windows
        bind z resize-pane -Z
        # bind ^L refresh-client
        bind C-r refresh-client
        # bind | split-window
        # bind s split-window -v -c "#{pane_current_path}"
        # bind v split-window -h -c "#{pane_current_path}"
        # bind '"' choose-window
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        # bind -r -T prefix , resize-pane -L 20
        # bind -r -T prefix . resize-pane -R 20
        # bind -r -T prefix - resize-pane -D 7
        # bind -r -T prefix = resize-pane -U 7
        bind : command-prompt
        bind * setw synchronize-panes
        # bind P set pane-border-status
        # bind c kill-pane
        # bind x swap-pane -D
        # bind S choose-session
        bind-key -T copy-mode-vi v send-keys -X begin-selection '';
    };
  };
}
