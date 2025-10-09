{tmux-sessionx, ...}: final: prev: {
  tmuxPlugins =
    prev.tmuxPlugins
    // {
      inherit
        (prev.mine)
        cheat-sh
        ;
      sessionx = tmux-sessionx.packages.${prev.system}.default;
    };
}
