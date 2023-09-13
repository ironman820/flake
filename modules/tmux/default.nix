{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.tmux;
in {
  options.ironman.tmux = {
    enable = mkBoolOpt true "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      baseIndex = 1;
      clock24 = true;
      enable = true;
      extraConfig = ''
        # Enable Mouse Navigation
        set -g mouse on

        # Alt+H/L to navigate Windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Vim-Like select/copy
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        # Open splits in the same directory
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        onedark-theme
        sensible
        vim-tmux-navigator
        yank
      ];
      secureSocket = false;
      shortcut = "Space";
    };
  };
}
