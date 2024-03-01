{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.yazi;
in {
  options.mine.home.yazi = {
    enable = mkBoolOpt (config.mine.home.user.settings.applications.fileManager == "yazi") "Enable the module";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ffmpegthumbnailer
      unar
      jq
      poppler_utils
      fd
      ripgrep
      fzf
      zoxide
    ];
    programs.yazi = {
      inherit (cfg) enable;
      enableBashIntegration = true;
      # keymap = {
      #   input.keymap = [
      #     {
      #       exec = "close";
      #       on = ["<C-q>"];
      #     }
      #     {
      #       exec = "close --submit";
      #       on = ["<Enter>"];
      #     }
      #     {
      #       exec = "escape";
      #       on = ["<Esc>"];
      #     }
      #     {
      #       exec = "backspace";
      #       on = ["<Backspace>"];
      #     }
      #   ];
      #   manager.keymap = [
      #     {
      #       exec = "escape";
      #       on = ["<Esc>"];
      #     }
      #     {
      #       exec = "quit";
      #       on = ["q"];
      #     }
      #     {
      #       exec = "close";
      #       on = ["<C-q>"];
      #     }
      #   ];
      # };
      settings = {
        log.enabled = false;
        manager = {
          show_hidden = true;
          sort_by = "natural";
          sort_dir_first = true;
          sort_reverse = false;
        };
      };
    };
    xdg.configFile."yazi/theme.toml".source = "${pkgs.catppuccin-yazi}/themes/mocha.toml";
  };
}
