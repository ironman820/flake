{ inputs, pkgs, ... }:
let inherit (pkgs.tmuxPlugins) mkTmuxPlugin;
in mkTmuxPlugin {
  pluginName = "cheat-sh";
  postInstall = ''
    sed -i -e "s|& cht\.sh|\& ${pkgs.cht-sh}/bin/cht.sh|g" $target/cheat.sh
  '';
  rtpFilePath = "cheat-sh.tmux";
  src = inputs.tmux-cheat-sh;
  version = "0.0.1";
}
