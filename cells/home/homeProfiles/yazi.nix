{
  cell,
  inputs,
  pkgs,
}: {
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
    enable = true;
    enableBashIntegration = true;
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
  # xdg.configFile."yazi/theme.toml".source = "${pkgs.catppuccin-yazi}/themes/mocha.toml";
}
