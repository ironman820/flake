{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkForce mkIf;
  inherit (lib.ironman) enabled mkBoolOpt mkOpt;
  inherit (lib.types) attrs int lines;
  inherit (pkgs) nerdfonts;

  cfg = config.ironman.home.kitty;
in {
  options.ironman.home.kitty = {
    enable = mkBoolOpt true "Setup kitty";
    extraConfig = mkOpt lines '''' "Extra configuration options";
    settings = mkOpt attrs {
      background_opacity = mkForce "0.9";
      cursor_shape = "beam";
      # hide_window_decorations = "yes";
      scrollback_lines = 10000;
      scrollback_pager = "bat";
      update_check_interval = 0;
    } "Settings from the kitty config file";
  };

  config = mkIf cfg.enable {
    ironman.home.kitty.extraConfig = ''
      include current-theme.conf
    '';
    home.file.".config/kitty/current-theme.conf".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/flake/modules/home/kitty/theme.conf";
    programs.kitty = {
      inherit (cfg) extraConfig settings;
      enable = true;
    };
  };
}
