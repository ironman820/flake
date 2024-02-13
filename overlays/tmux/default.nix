{ channels, ... }:
final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    inherit (prev.ironman)
      catppuccin-tmux cheat-sh tmux-fzf-url tmux-session-wizard;
  };
}
