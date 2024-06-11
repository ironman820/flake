{tmux-sessionx, ...}: final: prev: {
  tmuxPlugins =
    prev.tmuxPlugins
    // {
      inherit
        (prev.mine)
        catppuccin-tmux
        tmux-fzf-url
        ;
      sessionx = tmux-sessionx.packages.${prev.system}.default;
    };
}
