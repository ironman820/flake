{tmux-sessionx, ...}: final: prev: {
  tmuxPlugins =
    prev.tmuxPlugins
    // {
      inherit
        (prev.mine)
        catppuccin-tmux
        cheat-sh
        tmux-fzf-url
        tmux-session-wizard
        ;
      sessionx = tmux-sessionx.packages.${prev.system}.default;
    };
}
