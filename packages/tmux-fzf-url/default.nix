{ inputs, pkgs, ... }:
let inherit (pkgs.tmuxPlugins) mkTmuxPlugin;
in mkTmuxPlugin {
  pluginName = "tmux-fzf-url";
  rtpFilePath = "fzf-url.tmux";
  src = inputs.tmux-fzf-url;
  version = "0.0.47";
}
