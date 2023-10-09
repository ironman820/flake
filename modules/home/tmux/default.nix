{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) enabled mkBoolOpt mkOpt;
  inherit (lib.types) either int lines listOf package str submodule;
  inherit (pkgs.tmuxPlugins) onedark-theme sensible yank;

  cfg = config.ironman.home.tmux;
in {
  options.ironman.home.tmux = {
    enable = mkBoolOpt true "Setup tmux";
    baseIndex = mkOpt int 1 "Base number for windows";
    clock24 = mkBoolOpt true "Use a 24 hour clock";
    extraConfig = mkOpt lines '''' "Extra configuration options";
    historyLimit = mkOpt int 10000 "The number of lines to keep in scrollback history";
    keyMode = mkOpt str "vi" "Key style used for control";
    secureSocket = mkBoolOpt false "Use a secure socket to connect.";
    shortcut = mkOpt str "Space" "Default leader key that will be paired with <Ctrl>";
  };

  config = mkIf cfg.enable {
    ironman.home.tmux = {
      extraConfig = ''
        # Vim-Like select/copy
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        set-option -sa terminal-features ',xterm-kitty:RGB'
      '';
    };
    programs.tmux = {
      inherit (cfg) baseIndex clock24 extraConfig historyLimit keyMode secureSocket shortcut;
      enable = true;
      plugins = [
        {
          plugin = onedark-theme;
          extraConfig = "set -g @onedark_widgets '#{?client_prefix,<Prefix>,}'";
        }
        sensible
        yank
      ];
    };
  };
}
