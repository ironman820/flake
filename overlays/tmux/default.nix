{tmux-sessionx, ...}: final: prev: {
  tmuxPlugins =
    prev.tmuxPlugins
    // {
      inherit
        (prev.mine)
        catppuccin-tmux
        cheat-sh
        tmux-fzf-url
        ;
      sessionx = tmux-sessionx.packages.${prev.system}.default;
    };
}
