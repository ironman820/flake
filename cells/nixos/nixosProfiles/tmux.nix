{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars.tmux;
  l = nixpkgs.lib // mine.lib // builtins;
  p = mine.packages;
  t = l.types;
in {
  options.vars.tmux = {
    baseIndex = l.mkOpt t.int 1 "Base number for windows";
    clock24 = l.mkBoolOpt true "Use a 24 hour clock";
    customPaneNavigationAndResize = l.mkBoolOpt true "Use hjkl for navigation";
    escapeTime = l.mkOpt t.int 0 "Escape time";
    extraConfig = l.mkOpt t.lines "" "Extra configuration options";
    historyLimit =
      l.mkOpt t.int 1000000 "The number of lines to keep in scrollback history";
    keyMode = l.mkOpt t.str "vi" "Key style used for control";
    secureSocket = l.mkEnableOption "Use a secure socket to connect.";
    shortcut =
      l.mkOpt t.str "Space" "Default leader key that will be paired with <Ctrl>";
    terminal = l.mkOpt t.str "screen-256color" "Default terminal config";
  };

  config = {
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
      inherit
        (c)
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
        # catppuccin-tmux
        p.cheat-sh
        sensible
        p.sessionx
        yank
        p.tmux-fzf-url
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
        bind-key -T copy-mode-vi v send-keys -X begin-selection '';
    };
  };
}
