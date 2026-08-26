{
  flake.homeModules.starship = {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
    };
    xdg.configFile."starship.toml".source = ./starship.toml;
  };
}
