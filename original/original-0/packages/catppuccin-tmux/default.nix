{ inputs, pkgs }:

let inherit (pkgs.tmuxPlugins) mkTmuxPlugin;
in mkTmuxPlugin {
  pluginName = "catppuccin-tmux";
  rtpFilePath = "catppuccin.tmux";
  src = inputs.catppuccin-tmux;
  version = "2023-11-1";
}
