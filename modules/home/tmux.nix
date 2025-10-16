{
  flake.homeModules.tmux =
    {
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (pkgs) writeShellScript;
    in
    {
      programs = {
        bash.initExtra = ''
          if [ $DISPLAY ]; then
            [[ $- != *i* ]] && return
            [ -z "''${TMUX}" ] && { tmux new-session -A -s ${osConfig.ironman.user.name} && exit; }
          fi
        '';
        tmux = {
          baseIndex = 1;
          clock24 = true;
          customPaneNavigationAndResize = true;
          escapeTime = 0;
          historyLimit = 1000000;
          keyMode = "vi";
          secureSocket = false;
          shortcut = "Space";
          terminal = "screen-256color";
          enable = true;
          extraConfig = ''
            source-file ~/.config/tmux/tmux.reset.conf
            set-option -sa terminal-features ',kitty:RGB'

            set -g detach-on-destroy off
            set -g renumber-windows on
            set -g set-clipboard on
            set -g status-position top
            set -g mouse on

            bind-key -T copy-mode-vi v send-keys -X begin-selection
            bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
            bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
            bind-key -T prefix g display-popup -E -w 95% -h 95% -d '#{pane_current_path}' lazygit
          '';
          plugins = with pkgs.tmuxPlugins; [
            catppuccin
            sensible
            {
              plugin = tmux-sessionx;
              extraConfig = ''
                set -g @sessionx-bind 'o'
                set -g @sessionx-zoxide-mode 'on'
              '';
            }
            yank
            {
              plugin = fzf-tmux-url;
              extraConfig = ''
                set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
                set -g @fzf-url-history-limit '2000'
              '';
            }
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
          bind R source-file ~/.config/tmux/tmux.conf
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
