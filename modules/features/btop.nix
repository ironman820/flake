{
  flake.homeModules.btop = {
    home.shellAliases = {
      htop = "btop";
      top = "btop";
    };
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
        theme_background = false;
        vim_keys = true;
        rounded_corners = true;
        update_ms = 1500;
      };
    };
  };
}
