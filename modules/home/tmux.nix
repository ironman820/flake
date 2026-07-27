{
  flake.homeModules.tmux =
    {
      flakeRoot,
      pkgs,
      ...
    }:
    {
      imports = [
        "${flakeRoot}/modules/_tmux.nix"
      ];
      programs = {
        # bash.initExtra = ''
        #   if [ $DISPLAY ]; then
        #     [[ $- != *i* ]] && return
        #     [ -z "''${TMUX}" ] && { tmux new-session -A -s ${osConfig.ironman.user.name} && exit; }
        #   fi
        # '';
        tmux = {
          secureSocket = false;
          extraConfig = ''
            source-file /etc/tmux.reset.conf
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
    };
}
