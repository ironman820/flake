{
  flake.homeModules.ghostty = {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        background-opacity = 0.80;
        background-blur = true;
        font-family = "IosevkaTerm Nerd Font Mono";
        font-size = 12;
      };
      systemd.enable = true;
    };
  };
}
