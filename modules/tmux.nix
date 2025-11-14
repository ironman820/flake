{
  flake.nixosModules.tmux =
    {
      flakeRoot,
      pkgs,
      ...
    }:
    {
      imports = [
        "${flakeRoot}/modules/_tmux.nix"
      ];
      programs.tmux = {
        extraConfigBeforePlugins = ''
          source-file /etc/tmux.reset.conf

          set -g detach-on-destroy off
          set -g renumber-windows on
          set -g set-clipboard on
          set -g status-position top

          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          bind-key -T prefix g display-popup -E -w 95% -h 95% -d '#{pane_current_path}' lazygit
        '';
        plugins = with pkgs.tmuxPlugins; [
          catppuccin
          sensible
          tmux-sessionx
          yank
          fzf-tmux-url
        ];
      };
      environment.etc = {
        "tmux.reset.conf".text = ''
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
          bind R source-file /etc/tmux.conf
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
          bind-key -T copy-mode-vi v send-keys -X begin-selection
        '';
      };
    };
}
