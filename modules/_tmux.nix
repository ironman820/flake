{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    historyLimit = 1000000;
    keyMode = "vi";
    terminal = "tmux-256color";
  };
}
